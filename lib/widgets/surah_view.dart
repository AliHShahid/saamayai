import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/quran_service.dart';
import '../services/preference_service.dart';
import '../services/surah_pagination.dart';
import '../services/surah_pagination.dart';

class SurahView extends StatefulWidget {
  final int surahNumber;
  final String surahName;
  final int totalVerses;
  final VoidCallback? onSurahCompleted;
  final Stream<Map<String, dynamic>>? analysisStream;

  const SurahView({
    super.key,
    required this.surahNumber,
    required this.surahName,
    required this.totalVerses,
    this.onSurahCompleted,
    this.analysisStream,
  });

  @override
  State<SurahView> createState() => _SurahViewState();
}

class _SurahViewState extends State<SurahView> {
  final QuranService _quranService = QuranService();
  final PreferenceService _preferenceService = PreferenceService();
  
  // Pagination
  late PageController _pageController;
  List<List<int>> _pages = [];
  int _currentPage = 0;

  bool _isLoading = true;

  // Store analysis results keyed by Ayah Number
  final Map<int, Map<String, dynamic>> _verseResults = {};
  double _currentAccuracy = 0.0;
  
  // Stream subscription
  StreamSubscription? _analysisSubscription;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadData();
    _subscribeToAnalysis();
  }
  
  void _subscribeToAnalysis() {
    _analysisSubscription = widget.analysisStream?.listen((data) {
      _handleAnalysisComplete(data);
    });
  }

  void _generatePages() {
    if (!mounted) return;
    setState(() {
      _pages = SurahPagination.paginateSurah(
        widget.surahNumber,
        widget.totalVerses, 
        _quranService,
        wordsPerPage: 52, // Target words per page
      );
    });
  }

  @override
  void didUpdateWidget(covariant SurahView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.surahNumber != widget.surahNumber) {
      _verseResults.clear();
      _pageController.jumpToPage(0); // Reset to first page
      _loadData();
    }
    // Re-subscribe if stream changes (though likely same stream controller from parent)
    if (oldWidget.analysisStream != widget.analysisStream) {
       _analysisSubscription?.cancel();
       _subscribeToAnalysis();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _analysisSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await _quranService.loadQuranData();
    
    // Generate pages NOW that data is loaded
    _generatePages();

    // Load last saved progress
    final lastAyah = await _preferenceService.getSurahScrollPosition(widget.surahNumber);
    if (mounted) {
      setState(() => _isLoading = false);
      // Slight delay to ensure PageView is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _autoScrollToAyah(lastAyah);
      });
    }
  }

  /// Called repeatedly as WebSocket sends updates
  void _handleAnalysisComplete(Map<String, dynamic> result) {
    if (result.containsKey('status') && result['status'] == 'stopped') {
      _handleRecordingStopped();
      return;
    }

    if (result.containsKey('analysis') && result['analysis'] != null) {
      final analysis = result['analysis'];
      if (analysis is Map && analysis.containsKey('ayah')) {
        final int ayahNum = analysis['ayah'];
        final double acc = (analysis['accuracy'] ?? 0).toDouble();
        
        setState(() {
          _verseResults[ayahNum] = Map<String, dynamic>.from(analysis);
          _currentAccuracy = acc;
        });

        _autoScrollToAyah(ayahNum);

        // Check for Surah Completion
        if (ayahNum == widget.totalVerses && acc > 85.0) {
          print("🎉 Surah Completed! Triggering auto-next...");
          Future.delayed(const Duration(milliseconds: 1500), () {
            widget.onSurahCompleted?.call();
          });
        }
      }
    }
  }

  void _autoScrollToAyah(int ayahNum) {
    // Find which page this ayah belongs to
    int targetPage = -1;
    for (int i = 0; i < _pages.length; i++) {
      if (_pages[i].contains(ayahNum)) {
        targetPage = i;
        break;
      }
    }

    if (targetPage != -1 && targetPage != _currentPage) {
      _pageController.animateToPage(
        targetPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleRecordingStopped() {
    if (_currentAccuracy > 0) {
      print("💾 Saving Progress: ${widget.surahName} - $_currentAccuracy%");
      _preferenceService.saveRecitationResult(
        widget.surahNumber,
        widget.surahName,
        _currentAccuracy,
      ).then((_) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Progress saved! Accuracy: ${_currentAccuracy.toStringAsFixed(1)}%"),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: const Color(0xFF1B4332),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // --- 1. MAIN CONTENT AREA (PageView) ---
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: PageView.builder(
                controller: _pageController,
                reverse: true, // Arabic flows right-to-left
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  // Save progress (first ayah of the page)
                  if (_pages.isNotEmpty && index < _pages.length) {
                    final firstAyah = _pages[index].first;
                    _preferenceService.saveSurahScrollPosition(widget.surahNumber, firstAyah);
                  }
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                     padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                     child: _buildPageContent(index),
                  );
                },
              ),
            ),
          ),
        ),

        // --- 2. PAGE INDICATOR ---
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Page ${_currentPage + 1} of ${_pages.length}",
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white54 
                  : Colors.black54,
              fontSize: 12,
            ),
          ),
        ),

        // --- 3. STATS (RecordingWidget REMOVED) ---
        Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_currentAccuracy > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: _currentAccuracy > 80 ? Colors.green.shade50 : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _currentAccuracy > 80 ? Colors.green : Colors.orange),
                  ),
                  child: Text(
                    "Accuracy: ${_currentAccuracy.toStringAsFixed(1)}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _currentAccuracy > 80 ? Colors.green.shade800 : Colors.orange.shade800,
                    ),
                  ),
                ),
              // RecordingWidget REMOVED from here. It is now lifted to HomePage.
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageContent(int pageIndex) {
    if (pageIndex < 0 || pageIndex >= _pages.length) return const SizedBox();

    final theme = Theme.of(context);
    final isDark = false; // Force light
    final List<int> ayahsOnPage = _pages[pageIndex];

    List<InlineSpan> allSpans = [];

    // 1. Ornate Surah Header (Only on Page 0)
    if (pageIndex == 0) {
      allSpans.add(
        WidgetSpan(
          child: _buildNativeHeader(isDark),
        ),
      );

      // 2. Bismillah (Only on Page 0, and not for Surah 9)
      if (widget.surahNumber != 9) {
        allSpans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              child: Text(
                "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
                textAlign: TextAlign.center,
                style: AppThemes.arabicTextStyle.copyWith(
                  fontSize: 24,
                  color: Colors.black, // Force black
                  height: 1.5,
                ),
              ),
            ),
          ),
        );
        allSpans.add(const TextSpan(text: "\n"));
      }
    }

    // 3. Ayahs on this page
    for (int ayahNum in ayahsOnPage) {
      if (_verseResults.containsKey(ayahNum)) {
        allSpans.addAll(_getAnalyzedSpans(_verseResults[ayahNum]!, ayahNum, isDark));
      } else {
        allSpans.addAll(_getNormalSpans(ayahNum, isDark));
      }
    }

    return RichText(
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
      text: TextSpan(children: allSpans),
    );
  }

  List<InlineSpan> _getNormalSpans(int number, bool isDark) {
    // final textColor = isDark ? Colors.white : Colors.black87;
    final textColor = Colors.black87;
    final text = _quranService.getAyahText(widget.surahNumber, number);
    return [
      TextSpan(
        text: "$text ",
        style: AppThemes.arabicTextStyle.copyWith(
          fontSize: 24,
          color: textColor,
          height: 1.8,
        ),
      ),
      _buildAyahNumberSpan(number, isDark),
      const TextSpan(text: " "),
    ];
  }

  List<InlineSpan> _getAnalyzedSpans(Map<String, dynamic> analysis, int number, bool isDark) {
    final diffs = List<Map<String, dynamic>>.from(analysis['diff']);
    List<InlineSpan> spans = [];
    final baseColor = Colors.black;

    for (var item in diffs) {
      final word = item['word'];
      final status = item['status'];

      Color color = baseColor;
      TextDecoration decoration = TextDecoration.none;
      FontWeight weight = FontWeight.normal;

      if (status == 'correct') {
        color = const Color(0xFF2E7D32); // Lighter green
      } else if (status == 'wrong') {
        color = const Color(0xFFB71C1C); // Lighter red
        weight = FontWeight.bold;
      } else if (status == 'missing') {
        color = Colors.grey.shade400; // Light theme missing color
        decoration = TextDecoration.lineThrough;
      } else if (status == 'extra') {
        color = Colors.orange.shade400;
      }

      spans.add(
        TextSpan(
          text: "$word ",
          style: AppThemes.arabicTextStyle.copyWith(
            fontSize: 26, // Larger for current reciting ayah
            color: color,
            fontWeight: weight,
            decoration: decoration,
            decorationColor: color,
            height: 1.8,
          ),
        ),
      );
    }

    spans.add(_buildAyahNumberSpan(number, isDark));
    spans.add(const TextSpan(text: " "));
    return spans;
  }

  InlineSpan _buildAyahNumberSpan(int number, bool isDark) {
    final ringColor = const Color(0xFFD4AF37);
    final textColor = const Color(0xFFD4AF37);

    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ringColor, width: 1.5),
          color: Colors.transparent,
        ),
        child: Text(
          "$number",
          style: AppThemes.arabicTextStyle.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildNativeHeader(bool isDark) {
    // Light Mode Colors
    final lightOuterBorder = Colors.black;
    final lightInnerBg = const Color(0xFFF9F5EC);
    final lightText = Colors.black87;

    final borderColor = lightOuterBorder;
    final innerBgColor = lightInnerBg;
    final textColor = lightText;
    final starColor = Colors.black;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          _buildSideOrnament(borderColor, starColor),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: innerBgColor,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Center(
                  child: Text(
                    "سُورَةُ ${widget.surahName}",
                    style: AppThemes.arabicTextStyle.copyWith(
                      fontSize: 26,
                      color: textColor,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildSideOrnament(borderColor, starColor),
        ],
      ),
    );
  }

  Widget _buildSideOrnament(Color borderColor, Color iconColor) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Center(
        child: Icon(Icons.star_rate_rounded, size: 16, color: iconColor),
      ),
    );
  }
}

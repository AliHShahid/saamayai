import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../services/quran_service.dart';
import '../widgets/recording_widget.dart';

class SurahPage extends StatefulWidget {
  final int surahNumber;
  final String surahName;
  final int totalVerses;

  const SurahPage({
    super.key,
    required this.surahNumber,
    required this.surahName,
    required this.totalVerses,
  });

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  final QuranService _quranService = QuranService();
  bool _isLoading = true;

  // Store analysis results keyed by Ayah Number
  final Map<int, Map<String, dynamic>> _verseResults = {};

  @override
  void initState() {
    super.initState();
    _loadData();
    // Fire-and-forget warmup to prepare backend while user is viewing the page
    // This reduces the chance of "Cold Start" delay on the first recording.
    _quranService.loadQuranData().then((_) {}); 
    // We already call loadQuranData in _loadData, so we just want STT warmup:
    STTService.warmup(); 
  }

  Future<void> _loadData() async {
    await _quranService.loadQuranData();
    if (mounted) setState(() => _isLoading = false);
  }

  /// Called repeatedly as WebSocket sends updates
  void _handleAnalysisComplete(Map<String, dynamic> result) {
    if (result.containsKey('analysis') && result['analysis'] != null) {
      final analysis = result['analysis'];
      
      int ayahNum;
      try {
        ayahNum = int.parse(analysis['ayah'].toString());
      } catch (e) {
        debugPrint("❌ Error parsing Ayah Number: $e");
        return;
      }

      setState(() {
        _verseResults[ayahNum] = Map<String, dynamic>.from(analysis);
      });
      
      // Removed the popup dialog to avoid interrupting the user's flow
    } else {
      debugPrint("⚠️ Response missing 'analysis' key");
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Force light theme usage as per request
    final isDark = false; 

    // Colors that adapt to theme (forcing light)
    final bgColor = theme.scaffoldBackgroundColor;
    final contentBgColor = Colors.white;
    final borderColor = Colors.black87;
    final shadowColor = Colors.black.withOpacity(0.1);
    final textColor = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  // Main Quran Content
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    child: Column(
                      children: [
                        // Back button
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Mushaf Page Container
                        Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          decoration: BoxDecoration(
                            color: contentBgColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderColor, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: shadowColor,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: _buildQuranFlow(isDark),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Floating Recording Button
                  Positioned(
                    bottom: 24,
                    right: 24,
                    child: RecordingWidget(
                      surahNumber: widget.surahNumber,
                      onAnalysisComplete: _handleAnalysisComplete,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildQuranFlow(bool isDark) {
    List<InlineSpan> allSpans = [];

    // 1. Ornate Surah Header (Native)
    allSpans.add(
      WidgetSpan(
        child: _buildNativeHeader(isDark),
      ),
    );

    // 2. Bismillah - CENTERED using WidgetSpan
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
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
      // Add a new line after WidgetSpan so text starts on next line
      allSpans.add(const TextSpan(text: "\n"));
    }

    // 3. Ayahs
    for (int i = 1; i <= widget.totalVerses; i++) {
      if (_verseResults.containsKey(i)) {
        allSpans.addAll(_getAnalyzedSpans(_verseResults[i]!, i, isDark));
      } else {
        allSpans.addAll(_getNormalSpans(i, isDark));
      }
    }

    return RichText(
      textAlign: TextAlign.center, // Center alignment for the verses as well
      textDirection: TextDirection.rtl,
      text: TextSpan(children: allSpans),
    );
  }

  List<InlineSpan> _getNormalSpans(int number, bool isDark) {
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

    // Base text color for uncolored words
    final baseColor = Colors.black;

    for (var item in diffs) {
      final word = item['word'];
      final status = item['status'];

      Color color = baseColor;
      TextDecoration decoration = TextDecoration.none;
      FontWeight weight = FontWeight.normal;

      if (status == 'correct') {
        color = const Color(0xFF2E7D32); // Lighter green for dark mode visibility
      } else if (status == 'wrong') {
        color = const Color(0xFFB71C1C); // Lighter red
        weight = FontWeight.bold;
      } else if (status == 'missing') {
        color = Colors.grey.shade400;
        decoration = TextDecoration.lineThrough;
      } else if (status == 'extra') {
        color = Colors.orange.shade400;
      }

      spans.add(
        TextSpan(
          text: "$word ",
          style: AppThemes.arabicTextStyle.copyWith(
            fontSize: 24,
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
    // Light/Dark ring color
    final ringColor = Colors.black87; 
    
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ringColor, width: 1.5),
          color: Colors.white,
        ),
        child: Text(
          "$number",
          style: AppThemes.arabicTextStyle.copyWith(
            fontSize: 12, // Small for inside circle
            fontWeight: FontWeight.bold,
            color: ringColor,
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
    // Dark Mode Colors - logic kept but always utilizing light vars below
    // final darkOuterBorder = Colors.grey.shade600;
    // final darkInnerBg = const Color(0xFF2C2C2C);
    // final darkText = Colors.white;

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

import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import '../services/quran_service.dart';
import '../services/preference_service.dart';
import '../widgets/recording_widget.dart';

class SurahView extends StatefulWidget {
  final int surahNumber;
  final String surahName;
  final int totalVerses;

  const SurahView({
    super.key,
    required this.surahNumber,
    required this.surahName,
    required this.totalVerses,
  });

  @override
  State<SurahView> createState() => _SurahViewState();
}

class _SurahViewState extends State<SurahView> {
  final QuranService _quranService = QuranService();
  final PreferenceService _preferenceService = PreferenceService();
  bool _isLoading = true;

  // Store analysis results keyed by Ayah Number
  // Map<AyahNumber, AnalysisObject>
  final Map<int, Map<String, dynamic>> _verseResults = {};
  double _currentAccuracy = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant SurahView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.surahNumber != widget.surahNumber) {
      _verseResults.clear();
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await _quranService.loadQuranData();
    if (mounted) setState(() => _isLoading = false);
  }

  /// Called repeatedly as WebSocket sends updates
  void _handleAnalysisComplete(Map<String, dynamic> result) {
    // result format: {transcription: "...", analysis: {surah: X, ayah: Y, diff: [...]}, is_final: bool}
    print("DEBUG: _handleAnalysisComplete received: $result");
    
    if (result.containsKey('analysis') && result['analysis'] != null) {
      final analysis = result['analysis'];
      if (analysis is Map && analysis.containsKey('ayah')) {
        final int ayahNum = analysis['ayah'];
        final double acc = (analysis['accuracy'] ?? 0).toDouble();
        
        setState(() {
          _verseResults[ayahNum] = Map<String, dynamic>.from(analysis);
          _currentAccuracy = acc;
        });
      }
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
        // Optional: Show a subtle snackbar or toast
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
        // --- 1. MAIN CONTENT AREA (Mushaf Flow) ---
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                child: _buildQuranFlow(),
              ),
            ),
          ),
        ),

        // --- 2. RECORDER WIDGET + STATS ---
        Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            // color: Colors.white,
            // borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            // boxShadow: [
              // BoxShadow(
                // color: Colors.black12,
                // blurRadius: 10,
                // offset: const Offset(0, -4),
              // )
            // ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              if (_currentAccuracy > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
              RecordingWidget(
                surahNumber: widget.surahNumber,
                onAnalysisComplete: _handleAnalysisComplete,
                onRecordingStopped: _handleRecordingStopped,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuranFlow() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Adapt colors
    final borderColor = isDark ? Colors.grey.shade700 : const Color(0xFFD4AF37);
    final textColor = theme.colorScheme.onSurface;
    final ornamentColor = isDark ? Colors.grey.shade800 : const Color(0xFFF2EAD3);
    final ornamentBorder = isDark ? Colors.grey.shade600 : const Color(0xFFD4AF37);
    final headerTextColor = isDark ? Colors.white : const Color(0xFF1B4332);

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
              style: TextStyle(
                fontFamily: 'IndoPakFont',
                fontSize: 24,
                color: textColor,
                height: 1.5,
              ),
            ),
          ),
        ),
      );
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
      textAlign: TextAlign.center, // Matched SurahPage center alignment
      textDirection: TextDirection.rtl,
      text: TextSpan(children: allSpans),
    );
  }

  List<InlineSpan> _getNormalSpans(int number, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black87;
    final text = _quranService.getAyahText(widget.surahNumber, number);
    return [
      TextSpan(
        text: "$text ",
        style: TextStyle(
          fontFamily: 'IndoPakFont',
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
    final baseColor = isDark ? Colors.white : Colors.black;

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
        color = isDark ? Colors.grey.shade500 : Colors.grey.shade400;
        decoration = TextDecoration.lineThrough;
      } else if (status == 'extra') {
        color = Colors.orange.shade400;
      }

      spans.add(
        TextSpan(
          text: "$word ",
          style: TextStyle(
            fontFamily: 'IndoPakFont',
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
    final ringColor = isDark ? Colors.white70 : const Color(0xFFD4AF37);
    final textColor = isDark ? Colors.white70 : const Color(0xFFD4AF37);

    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ringColor, width: 1.5),
          color: isDark ? Colors.grey.shade800 : Colors.transparent, // transparent to show bg
        ),
        child: Text(
          "$number",
          style: TextStyle(
            fontFamily: 'IndoPakFont',
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
    // Dark Mode Colors
    final darkOuterBorder = Colors.grey.shade600;
    final darkInnerBg = const Color(0xFF2C2C2C);
    final darkText = Colors.white;

    final borderColor = isDark ? darkOuterBorder : lightOuterBorder;
    final innerBgColor = isDark ? darkInnerBg : lightInnerBg;
    final textColor = isDark ? darkText : lightText;
    final starColor = isDark ? Colors.grey.shade400 : Colors.black;

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
                    style: TextStyle(
                      fontFamily: 'IndoPakFont',
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

// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import '../services/quran_service.dart';

// // class SurahPage extends StatefulWidget {
// //   final int surahNumber;
// //   final String surahName;
// //   final int totalVerses;

// //   const SurahPage({
// //     super.key,
// //     required this.surahNumber,
// //     required this.surahName,
// //     required this.totalVerses,
// //   });

// //   @override
// //   State<SurahPage> createState() => _SurahPageState();
// // }

// // class _SurahPageState extends State<SurahPage> {
// //   final QuranService _quranService = QuranService();
// //   bool _isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadData();
// //   }

// //   Future<void> _loadData() async {
// //     await _quranService.loadQuranData();
// //     if (mounted) {
// //       setState(() {
// //         _isLoading = false;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     // Special case: Al-Fatiha is usually centered.
// //     final bool isFatiha = widget.surahNumber == 1;
// //     final theme = Theme.of(context);
// //     final isDark = theme.brightness == Brightness.dark;
// //     final borderColor = isDark ? Colors.grey.shade700 : Colors.black;
// //     final borderColorLight = isDark ? Colors.grey.shade600 : Colors.black54;
// //     final textColor = isDark ? Colors.grey.shade100 : Colors.black;
// //     final headerBgColor =
// //         isDark ? Colors.grey.shade800 : const Color(0xFFF5F5F5);

// //     return Scaffold(
// //       backgroundColor: theme.scaffoldBackgroundColor,
// //       appBar: AppBar(
// //         elevation: 0,
// //         leading: IconButton(
// //           icon: Icon(Icons.arrow_back,
// //               color: isDark ? Colors.grey.shade300 : Colors.black),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //         title: Text(
// //           "Surah ${widget.surahName}",
// //           style: GoogleFonts.poppins(
// //               color: textColor, fontWeight: FontWeight.w500),
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: _isLoading
// //           ? Center(
// //               child:
// //                   CircularProgressIndicator(color: theme.colorScheme.primary))
// //           : SafeArea(
// //               child: Container(
// //                 margin: const EdgeInsets.all(12),
// //                 decoration: BoxDecoration(
// //                   border: Border.all(color: borderColor, width: 2),
// //                   borderRadius: BorderRadius.circular(4),
// //                 ),
// //                 child: Container(
// //                   margin: const EdgeInsets.all(3),
// //                   decoration: BoxDecoration(
// //                     border: Border.all(color: borderColorLight, width: 1),
// //                   ),
// //                   child: Column(
// //                     children: [
// //                       // ----- 1. DECORATIVE SURAH HEADER -----
// //                       Container(
// //                         width: double.infinity,
// //                         margin: const EdgeInsets.symmetric(
// //                             horizontal: 16, vertical: 16),
// //                         padding: const EdgeInsets.symmetric(vertical: 8),
// //                         decoration: BoxDecoration(
// //                           color: headerBgColor,
// //                           border: Border.all(
// //                               color: isDark
// //                                   ? Colors.grey.shade600
// //                                   : Colors.black87),
// //                           image: const DecorationImage(
// //                             image: AssetImage(
// //                                 'assets/Start.png'), // Using as a texture if available, else solid
// //                             fit: BoxFit.cover,
// //                             opacity: 0.05,
// //                           ),
// //                         ),
// //                         child: Center(
// //                           child: Text(
// //                             "سُورَةُ ${widget.surahName}", // Arabic text approximation
// //                             style: GoogleFonts.amiri(
// //                               fontSize: 22,
// //                               fontWeight: FontWeight.bold,
// //                               color: textColor,
// //                             ),
// //                           ),
// //                         ),
// //                       ),

// //                       // ----- 2. BISMILLAH (Except Surah Tawbah #9) -----
// //                       if (widget.surahNumber != 9)
// //                         Padding(
// //                           padding: const EdgeInsets.only(bottom: 16.0),
// //                           child: Text(
// //                             "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
// //                             textAlign: TextAlign.center,
// //                             style: GoogleFonts.amiri(
// //                               fontSize: 24,
// //                               fontWeight: FontWeight.w600,
// //                             ),
// //                           ),
// //                         ),

// //                       // ----- 3. VERSES LIST -----
// //                       Expanded(
// //                         child: ListView.builder(
// //                           padding: const EdgeInsets.symmetric(
// //                               horizontal: 16, vertical: 8),
// //                           itemCount: widget.totalVerses,
// //                           itemBuilder: (context, index) {
// //                             final ayahNumber = index + 1;
// //                             final ayahText = _quranService.getAyahText(
// //                                 widget.surahNumber, ayahNumber);

// //                             return Padding(
// //                               padding: const EdgeInsets.only(bottom: 12.0),
// //                               child: RichText(
// //                                 textAlign: isFatiha
// //                                     ? TextAlign.center
// //                                     : TextAlign.justify,
// //                                 textDirection: TextDirection.rtl,
// //                                 text: TextSpan(
// //                                   children: [
// //                                     // The Ayah Text
// //                                     TextSpan(
// //                                       text: ayahText,
// //                                       style: GoogleFonts.amiri(
// //                                         fontSize:
// //                                             24, // Large font size like Mushaf
// //                                         color: textColor,
// //                                         height: 2.0, // Good line spacing
// //                                       ),
// //                                     ),
// //                                     // The Ornamental End Symbol with Number
// //                                     TextSpan(
// //                                       text: " ۝$ayahNumber ",
// //                                       style: GoogleFonts.amiri(
// //                                         fontSize: 24,
// //                                         color: const Color(
// //                                             0xFFD4AF37), // Gold color for the number
// //                                         fontWeight: FontWeight.bold,
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../services/quran_service.dart';
// import '../widgets/recording_widget.dart'; // Import your recording widget

// class SurahPage extends StatefulWidget {
//   final int surahNumber;
//   final String surahName;
//   final int totalVerses;

//   const SurahPage({
//     super.key,
//     required this.surahNumber,
//     required this.surahName,
//     required this.totalVerses,
//   });

//   @override
//   State<SurahPage> createState() => _SurahPageState();
// }

// class _SurahPageState extends State<SurahPage> {
//   final QuranService _quranService = QuranService();
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     await _quranService.loadQuranData();
//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFFFDF5),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFFFDF5),
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),
//         title: Text(
//           "Surah ${widget.surahName}",
//           style: GoogleFonts.poppins(
//               color: Colors.black, fontWeight: FontWeight.w500),
//         ),
//         centerTitle: true,
//       ),
//       // Use Column to split: Top = List (Expanded), Bottom = Recorder
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 // 1. The Quran Text (Scrollable Area)
//                 Expanded(
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 12),
//                     decoration: BoxDecoration(
//                       border: Border(
//                         left: BorderSide(
//                             color: const Color(0xFF8B4513), width: 2),
//                         right: BorderSide(
//                             color: const Color(0xFF8B4513), width: 2),
//                       ),
//                     ),
//                     child: ListView.builder(
//                       padding: const EdgeInsets.fromLTRB(
//                           16, 16, 16, 80), // Extra bottom padding for safety
//                       itemCount: widget.totalVerses + 1, // +1 for Header
//                       itemBuilder: (context, index) {
//                         // Header Item (Surah Name & Bismillah)
//                         if (index == 0) {
//                           return Column(
//                             children: [
//                               Container(
//                                 margin: const EdgeInsets.only(bottom: 16),
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 8, horizontal: 24),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFF2EAD3),
//                                   border: Border.all(color: Colors.black87),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Text(
//                                   "سُورَةُ ${widget.surahName}",
//                                   style: GoogleFonts.amiri(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               if (widget.surahNumber != 9)
//                                 Padding(
//                                   padding: const EdgeInsets.only(bottom: 24.0),
//                                   child: Text(
//                                     "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
//                                     textAlign: TextAlign.center,
//                                     style: GoogleFonts.amiri(fontSize: 24),
//                                   ),
//                                 ),
//                             ],
//                           );
//                         }

//                         // Verse Items
//                         final ayahNumber = index; // Since index 0 was header
//                         final ayahText = _quranService.getAyahText(
//                             widget.surahNumber, ayahNumber);

//                         return Padding(
//                           padding: const EdgeInsets.only(bottom: 16.0),
//                           child: RichText(
//                             textAlign: TextAlign.right,
//                             textDirection: TextDirection.rtl,
//                             text: TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: ayahText,
//                                   style: GoogleFonts.amiri(
//                                     fontSize: 24,
//                                     color: Colors.black,
//                                     height: 2.0,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: " ۝$ayahNumber ",
//                                   style: GoogleFonts.amiri(
//                                     fontSize: 24,
//                                     color: const Color(0xFFD4AF37),
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),

//                 // 2. The Recording Widget (Fixed at Bottom)
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         offset: const Offset(0, -4),
//                         blurRadius: 10,
//                       ),
//                     ],
//                     borderRadius:
//                         const BorderRadius.vertical(top: Radius.circular(20)),
//                   ),
//                   child: const RecordingWidget(), // Your existing widget
//                 ),
//               ],
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  // To store mistake analysis results
  Map<String, dynamic>? _analysisResult;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _quranService.loadQuranData();
    if (mounted) setState(() => _isLoading = false);
  }

  void _handleAnalysisComplete(Map<String, dynamic> result) {
    if (result.containsKey('analysis')) {
      setState(() {
        _analysisResult = result['analysis']; // Store the backend analysis
      });

      // Optional: Show accuracy snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Recitation Accuracy: ${result['analysis']['accuracy']}%"),
          backgroundColor: result['analysis']['accuracy'] > 80
              ? Colors.green
              : Colors.orange,
        ),
      );
    } else if (result.containsKey('error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error']), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
      appBar: AppBar(
        title: Text("Surah ${widget.surahName}"),
        backgroundColor: const Color(0xFFFFFDF5),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: GoogleFonts.poppins(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // --- 1. QURAN TEXT DISPLAY ---
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        vertical:
                            BorderSide(color: Colors.brown.shade200, width: 4),
                      ),
                    ),
                    child: _analysisResult == null
                        ? _buildStaticQuranList() // Default View
                        : _buildMistakeHighlightedView(), // Mistake View
                  ),
                ),

                // --- 2. RECORDER ---
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: const Offset(0, -4))
                    ],
                  ),
                  child: RecordingWidget(
                    surahNumber: widget.surahNumber,
                    onAnalysisComplete: _handleAnalysisComplete,
                  ),
                ),
              ],
            ),
    );
  }

  // --- VIEW 1: NORMAL QURAN TEXT (Before Reciting) ---
  Widget _buildStaticQuranList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      itemCount: widget.totalVerses + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _buildHeader();

        final ayahNumber = index;
        final ayahText =
            _quranService.getAyahText(widget.surahNumber, ayahNumber);

        return _buildAyahItem(ayahText, ayahNumber, Colors.black);
      },
    );
  }

  // --- VIEW 2: MISTAKE HIGHLIGHTED TEXT (After Reciting) ---
  Widget _buildMistakeHighlightedView() {
    // We need to reconstruct the full text from the 'diff' list provided by backend
    final diffs = List<Map<String, dynamic>>.from(_analysisResult!['diff']);

    List<TextSpan> textSpans = [];

    for (var item in diffs) {
      final word = item['word'];
      final status = item['status'];

      Color color;
      if (status == 'correct') {
        color = Colors.green.shade800; // Correct
      } else if (status == 'wrong') {
        color = Colors.red.shade700; // Mispronounced
      } else if (status == 'missing') {
        color = Colors.grey; // Skipped words (Grey or Red outline)
      } else {
        color = Colors.orange; // Extra words
      }

      textSpans.add(
        TextSpan(
          text: "$word ",
          style: GoogleFonts.amiri(
            fontSize: 24,
            color: color,
            fontWeight: status == 'wrong' ? FontWeight.bold : FontWeight.normal,
            decoration: status == 'wrong'
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          RichText(
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
            text: TextSpan(children: textSpans),
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF2EAD3),
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "سُورَةُ ${widget.surahName}",
            style: GoogleFonts.amiri(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        if (widget.surahNumber != 9)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
              style:
                  GoogleFonts.amiri(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  Widget _buildAyahItem(String text, int number, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: RichText(
        textAlign: TextAlign.justify,
        textDirection: TextDirection.rtl,
        text: TextSpan(
          children: [
            TextSpan(
              text: text,
              style: GoogleFonts.amiri(fontSize: 24, color: color, height: 2.0),
            ),
            TextSpan(
              text: " ۝$number ",
              style: GoogleFonts.amiri(
                  fontSize: 24, color: const Color(0xFFD4AF37)),
            ),
          ],
        ),
      ),
    );
  }
}

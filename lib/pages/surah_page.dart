// import 'package:flutter/material.dart';
// import '../services/quran_service.dart';

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
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(widget.surahName),
//         centerTitle: true,
//         backgroundColor: Colors.green.shade50,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               padding: const EdgeInsets.all(20),
//               itemCount: widget.totalVerses,
//               itemBuilder: (context, index) {
//                 final ayahNumber = index + 1;
//                 final ayahText =
//                     _quranService.getAyahText(widget.surahNumber, ayahNumber);

//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 24),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       // Ayah Number Header
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Colors.green.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               "${widget.surahNumber}:$ayahNumber",
//                               style: TextStyle(
//                                 color: Colors.green.shade800,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       // Arabic Text
//                       Directionality(
//                         textDirection: TextDirection.rtl,
//                         child: Text(
//                           ayahText,
//                           textAlign: TextAlign.right,
//                           style: const TextStyle(
//                             fontFamily:
//                                 'Scheherazade New', // Ensure you have an Arabic font or remove this line to use default
//                             fontSize: 26,
//                             height: 1.8,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       const Divider(thickness: 0.5),
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/quran_service.dart';

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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _quranService.loadQuranData();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Special case: Al-Fatiha is usually centered.
    final bool isFatiha = widget.surahNumber == 1;

    return Scaffold(
      backgroundColor:
          const Color(0xFFFFFDF5), // Slightly off-white paper color
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFDF5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Surah ${widget.surahName}",
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : SafeArea(
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 1),
                  ),
                  child: Column(
                    children: [
                      // ----- 1. DECORATIVE SURAH HEADER -----
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          border: Border.all(color: Colors.black87),
                          image: const DecorationImage(
                            image: AssetImage(
                                'assets/Start.png'), // Using as a texture if available, else solid
                            fit: BoxFit.cover,
                            opacity: 0.05,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "سُورَةُ ${widget.surahName}", // Arabic text approximation
                            style: GoogleFonts.amiri(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      // ----- 2. BISMILLAH (Except Surah Tawbah #9) -----
                      if (widget.surahNumber != 9)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.amiri(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                      // ----- 3. VERSES LIST -----
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          itemCount: widget.totalVerses,
                          itemBuilder: (context, index) {
                            final ayahNumber = index + 1;
                            final ayahText = _quranService.getAyahText(
                                widget.surahNumber, ayahNumber);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: RichText(
                                textAlign: isFatiha
                                    ? TextAlign.center
                                    : TextAlign.justify,
                                textDirection: TextDirection.rtl,
                                text: TextSpan(
                                  children: [
                                    // The Ayah Text
                                    TextSpan(
                                      text: ayahText,
                                      style: GoogleFonts.amiri(
                                        fontSize:
                                            24, // Large font size like Mushaf
                                        color: Colors.black,
                                        height: 2.0, // Good line spacing
                                      ),
                                    ),
                                    // The Ornamental End Symbol with Number
                                    TextSpan(
                                      text: " ۝$ayahNumber ",
                                      style: GoogleFonts.amiri(
                                        fontSize: 24,
                                        color: const Color(
                                            0xFFD4AF37), // Gold color for the number
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

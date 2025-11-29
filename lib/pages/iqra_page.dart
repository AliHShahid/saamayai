// import 'package:flutter/material.dart';
// import 'home_page.dart';
// import 'surah_page.dart';
// import '../services/quran_service.dart';
// import '../widgets/nav_drawer.dart';

// class IqraPage extends StatelessWidget {
//   const IqraPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Iqra"),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.keyboard_double_arrow_left_outlined),
//           onPressed: () {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (_) => const HomePage()),
//               (route) => false,
//             );
//           },
//         ),
//       ),
//       drawer: const NavDrawer(),
//       body: ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: 114,
//         separatorBuilder: (context, index) => const Divider(height: 1),
//         itemBuilder: (context, index) {
//           final surahNumber = index + 1;
//           final surahName = QuranService.surahNames[index];
//           final verseCount = QuranService.surahVerseCounts[index];

//           return ListTile(
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             leading: Container(
//               width: 40,
//               height: 40,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.green.shade50,
//                 border: Border.all(color: Colors.green, width: 1.5),
//               ),
//               child: Text(
//                 "$surahNumber",
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green,
//                 ),
//               ),
//             ),
//             title: Text(
//               surahName,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16,
//               ),
//             ),
//             subtitle: Text("$verseCount Verses"),
//             trailing: const Icon(Icons.arrow_forward_ios_rounded,
//                 size: 16, color: Colors.grey),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => SurahPage(
//                     surahNumber: surahNumber,
//                     surahName: surahName,
//                     totalVerses: verseCount,
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'surah_page.dart';
import '../services/quran_service.dart';
import '../widgets/nav_drawer.dart';

class IqraPage extends StatelessWidget {
  const IqraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iqra"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_double_arrow_left_outlined),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            );
          },
        ),
      ),
      drawer: const NavDrawer(),
      // Remove default padding for a full-width list look
      body: ListView.builder(
        itemCount: 114,
        itemBuilder: (context, index) {
          final surahNumber = index + 1;
          final surahName = QuranService.surahNames[index];
          final verseCount = QuranService.surahVerseCounts[index];

          // Alternating background color logic
          final bool isEven = index % 2 == 0;
          final backgroundColor = isEven ? Colors.grey.shade100 : Colors.white;

          return Container(
            color: backgroundColor, // Alternating color like your image
            child: ListTile(
              // These parameters tighten the spacing
              visualDensity: VisualDensity.compact,
              dense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),

              leading: Container(
                width: 32, // Smaller circle
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: Text(
                  "$surahNumber",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: Colors.green,
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    surahName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  // Optional: You could add Arabic name here if available in your data
                ],
              ),
              subtitle: Text(
                "$verseCount Verses",
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 12, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SurahPage(
                      surahNumber: surahNumber,
                      surahName: surahName,
                      totalVerses: verseCount,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

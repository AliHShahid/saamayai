// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../widgets/nav_drawer.dart';
// import '../widgets/recording_widget.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = Supabase.instance.client.auth.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Saamay'),
//         leading: Builder(
//           builder: (context) => IconButton(
//             icon: const Icon(Icons.drag_handle_sharp),
//             onPressed: () => Scaffold.of(context).openDrawer(),
//           ),
//         ),
//       ),
//       drawer: const NavDrawer(),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Text(
//               'Welcome',
//               // 'Welcome${user?.email != null ? ', ${user!.email}' : ''}!',
//               style: Theme.of(context).textTheme.titleMedium,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             const RecordingWidget(),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/nav_drawer.dart';
import '../services/quran_service.dart';
import 'surah_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Saamay - Select Surah"),
        centerTitle: true,
        actions: [
          // Optional: Keep a small profile icon or similar
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search later
            },
          ),
        ],
      ),
      drawer: const NavDrawer(),
      body: Column(
        children: [
          // Welcome Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.green.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome, ${user?.email?.split('@')[0] ?? 'Reciter'}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Select a Surah to practice recitation.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Surah List
          Expanded(
            child: ListView.separated(
              itemCount: 114,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final surahNumber = index + 1;
                final surahName = QuranService.surahNames[index];
                final verseCount = QuranService.surahVerseCounts[index];

                // Alternating background color logic
                final bool isEven = index % 2 == 0;
                final backgroundColor =
                    isEven ? Colors.white : Colors.grey.shade50;

                return Container(
                  color: backgroundColor,
                  child: ListTile(
                    visualDensity: VisualDensity.compact,
                    dense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green, width: 1.5),
                      ),
                      child: Text(
                        "$surahNumber",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    title: Text(
                      surahName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    subtitle: Text(
                      "$verseCount Verses",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: Colors.grey),
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
          ),
        ],
      ),
    );
  }
}

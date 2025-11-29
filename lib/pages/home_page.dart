// // // lib/pages/home_page.dart
// // import 'package:flutter/material.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import '../widgets/nav_drawer.dart';
// // import '../widgets/recording_widget.dart';

// // class HomePage extends StatelessWidget {
// //   const HomePage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final user = Supabase.instance.client.auth.currentUser;
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Saamay'),
// //         leading: Builder(
// //           builder: (context) => IconButton(
// //             // icon: Image.asset(
// //             //   'assets/icon/Menu Button.png', // 👈 your custom menu icon
// //             //   width: 28,
// //             //   height: 28,
// //             // ),
// //             icon: const Icon(Icons.drag_handle_sharp),
// //             onPressed: () {
// //               Scaffold.of(context).openDrawer(); // open drawer
// //             },
// //           ),
// //         ),
// //         // actions: [
// //         //   IconButton(
// //         //     onPressed: () async {
// //         //       await Supabase.instance.client.auth.signOut();
// //         //       if (context.mounted) {
// //         //         Navigator.of(context).popUntil((r) => r.isFirst);
// //         //       }
// //         //     },
// //         //     icon: const Icon(Icons.logout),
// //         //     tooltip: 'Sign out',
// //         //   ),
// //         // ],
// //       ),
// //       drawer: const NavDrawer(), // 👈 this connects Module 3
// //       body: Center(
// //         child: Text(
// //           'Welcome${user?.email != null ? ', ${user!.email}' : ''}!',
// //           style: Theme.of(context).textTheme.titleMedium,
// //           textAlign: TextAlign.center,
// //         ),
// //       ),
// //     );
// //   }
// // }

// // lib/pages/home_page.dart
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
//             onPressed: () {
//               Scaffold.of(context).openDrawer();
//             },
//           ),
//         ),
//       ),
//       drawer: const NavDrawer(),

//       // ----- MAIN UI -----
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Welcome text
//             Text(
//               'Welcome${user?.email != null ? ', ${user!.email}' : ''}!',
//               style: Theme.of(context).textTheme.titleMedium,
//               textAlign: TextAlign.center,
//             ),

//             const SizedBox(height: 24),

//             // Recording Widget
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
import '../widgets/recording_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saamay'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.drag_handle_sharp),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Welcome',
              // 'Welcome${user?.email != null ? ', ${user!.email}' : ''}!',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const RecordingWidget(),
          ],
        ),
      ),
    );
  }
}

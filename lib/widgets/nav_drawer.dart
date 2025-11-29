// // import 'package:flutter/material.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'package:provider/provider.dart';

// // import '../pages/profile_page.dart';
// // import '../pages/about_page.dart';
// // import '../pages/feedback.dart';
// // import '../pages/progress_page.dart';
// // import '../pages/auth_page.dart';
// // // import '../pages/settings_page.dart';
// // import '../theme_provider.dart';

// // class NavDrawer extends StatelessWidget {
// //   const NavDrawer({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final themeProvider = Provider.of<ThemeProvider>(context);
// //     return Container(
// //       width: 145,
// //       margin: const EdgeInsets.only(top: 65, bottom: 300, left: 10, right: 60),
// //       child: Drawer(
// //         shape: const RoundedRectangleBorder(
// //           borderRadius: BorderRadius.only(
// //             topRight: Radius.circular(12.5),
// //             bottomRight: Radius.circular(12.5),
// //             topLeft: Radius.circular(12.5),
// //             bottomLeft: Radius.circular(12.5),
// //           ),
// //         ),
// //         child: Column(
// //           children: [
// //             // Header (empty with fixed height)
// //             const SizedBox(height: 8),

// //             // Drawer body
// //             Expanded(
// //               child: ListView(
// //                 padding: EdgeInsets.zero,
// //                 children: [
// //                   // ListTile(
// //                   //   leading: const Icon(Icons.dashboard),
// //                   //   title: const Text('Dashboard'),
// //                   //   onTap: () {
// //                   //     Navigator.pushReplacement(
// //                   //       context,
// //                   //       MaterialPageRoute(builder: (_) => const HomePage()),
// //                   //     );
// //                   //   },
// //                   // ),
// //                   ListTile(
// //                     // leading: const Icon(Icons.history),
// //                     title: const Text('History'),
// //                     onTap: () {
// //                       Navigator.pushReplacement(
// //                         context,
// //                         MaterialPageRoute(builder: (_) => const ProgressPage()),
// //                       );
// //                     },
// //                   ),
// //                   ListTile(
// //                     // leading: const Icon(Icons.person),
// //                     title: const Text('Profile'),
// //                     onTap: () {
// //                       Navigator.pushReplacement(
// //                         context,
// //                         MaterialPageRoute(builder: (_) => const ProfilePage()),
// //                       );
// //                     },
// //                   ),
// //                   ListTile(
// //                     // leading: const Icon(Icons.info),
// //                     title: const Text('About'),
// //                     onTap: () {
// //                       Navigator.pushReplacement(
// //                         context,
// //                         MaterialPageRoute(builder: (_) => const AboutPage()),
// //                       );
// //                     },
// //                   ),
// //                   ListTile(
// //                     // leading: const Icon(Icons.info),
// //                     title: const Text('Feedback'),
// //                     onTap: () {
// //                       Navigator.pushReplacement(
// //                         context,
// //                         MaterialPageRoute(builder: (_) => const FeedbackForm()),
// //                       );
// //                     },
// //                   ),

// //                   // const Divider(),
// //                   // ✅ Theme switcher dropdown
// //                   Padding(
// //                     padding: const EdgeInsets.all(12.0),
// //                     child: DropdownButton<String>(
// //                       value: themeProvider.themeName,
// //                       isExpanded: true,
// //                       items: const [
// //                         DropdownMenuItem(
// //                             value: "Nature Green",
// //                             child: Text("🌿 Nature Green")),
// //                         DropdownMenuItem(
// //                             value: "Freezed Ice",
// //                             child: Text("❄️ Freezed Ice")),
// //                         DropdownMenuItem(value: "Dark", child: Text("🌙 Dark")),
// //                         DropdownMenuItem(
// //                             value: "White", child: Text("🌙 Light")),
// //                       ],
// //                       onChanged: (value) {
// //                         if (value != null) {
// //                           themeProvider.setTheme(value);
// //                         }
// //                       },
// //                     ),
// //                   ),
// //                   // const Divider(),
// //                   ListTile(
// //                     // leading: const Icon(Icons.logout, color: Colors.red),
// //                     title: const Text('Logout'),
// //                     onTap: () async {
// //                       await Supabase.instance.client.auth.signOut();
// //                       if (context.mounted) {
// //                         Navigator.of(context).pushAndRemoveUntil(
// //                           MaterialPageRoute(builder: (_) => const AuthPage()),
// //                           (route) => false,
// //                         );
// //                       }
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             // Footer (empty with fixed height)
// //             const SizedBox(height: 3),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:provider/provider.dart';

// import '../pages/profile_page.dart';
// import '../pages/progress_page.dart';
// import '../pages/auth_page.dart';
// import '../pages/settings_page.dart'; // Import the new settings page
// import '../theme_provider.dart';

// class NavDrawer extends StatelessWidget {
//   const NavDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final user = Supabase.instance.client.auth.currentUser;
//     final email = user?.email ?? "Guest";

//     return Drawer(
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(20),
//           bottomRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         children: [
//           // ----- 1. HEADER SECTION -----
//           UserAccountsDrawerHeader(
//             decoration: const BoxDecoration(
//               color: Colors.green,
//               image: DecorationImage(
//                 image: AssetImage('assets/Start.png'),
//                 fit: BoxFit.cover,
//                 opacity: 0.1,
//               ),
//             ),
//             currentAccountPicture: const CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Icon(Icons.person, size: 40, color: Colors.green),
//             ),
//             accountName: const Text(
//               "Welcome",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             accountEmail: Text(email),
//           ),

//           // ----- 2. MENU ITEMS -----
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               children: [
//                 _buildMenuItem(
//                   context,
//                   icon: Icons.history_rounded,
//                   title: 'History',
//                   onTap: () => Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (_) => const ProgressPage()),
//                   ),
//                 ),
//                 _buildMenuItem(
//                   context,
//                   icon: Icons.person_rounded,
//                   title: 'Profile',
//                   onTap: () => Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (_) => const ProfilePage()),
//                   ),
//                 ),

//                 const Divider(), // Visual separator

//                 // New Settings Item
//                 _buildMenuItem(
//                   context,
//                   icon: Icons.settings_rounded,
//                   title: 'Settings',
//                   onTap: () {
//                     // Navigate to Settings Page (keep drawer open logic or push)
//                     Navigator.pop(context); // Close drawer first
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => const SettingsPage()),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),

//           // ----- 3. LOGOUT BUTTON -----
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: ListTile(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               tileColor: Colors.red.shade50,
//               leading: const Icon(Icons.logout, color: Colors.red),
//               title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
//               onTap: () async {
//                 await Supabase.instance.client.auth.signOut();
//                 if (context.mounted) {
//                   Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(builder: (_) => const AuthPage()),
//                     (route) => false,
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuItem(BuildContext context,
//       {required IconData icon, required String title, required VoidCallback onTap}) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.grey.shade700),
//       title: Text(
//         title,
//         style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w500),
//       ),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       onTap: onTap,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       hoverColor: Colors.green.withOpacity(0.1),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../pages/profile_page.dart';
import '../pages/progress_page.dart';
import '../pages/auth_page.dart';
import '../pages/settings_page.dart';
import '../pages/iqra_page.dart'; // Import Iqra Page

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // This restores your classic slim, floating drawer style
    return Container(
      width: 145, // Slim width as requested
      margin: const EdgeInsets.only(top: 65, bottom: 300, left: 10, right: 60),
      child: Drawer(
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.5)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 15),

            // App Logo or Icon at top of mini drawer
            // const CircleAvatar(
            //   radius: 25,
            //   backgroundColor: Colors.green,
            //   child: Icon(Icons.menu_book, color: Colors.white, size: 28),
            // ),

            const SizedBox(height: 10),

            // Drawer body
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // 1. IQRA (READ)
                  _buildCompactMenuItem(
                    context,
                    icon: Icons.menu_book_rounded,
                    title: 'Iqra',
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const IqraPage()),
                    ),
                  ),

                  // 2. HISTORY
                  _buildCompactMenuItem(
                    context,
                    icon: Icons.history_rounded,
                    title: 'History',
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ProgressPage()),
                    ),
                  ),

                  // 3. PROFILE
                  _buildCompactMenuItem(
                    context,
                    icon: Icons.person_rounded,
                    title: 'Profile',
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    ),
                  ),

                  const Divider(indent: 20, endIndent: 20),

                  // 4. SETTINGS (Contains Theme, About, Feedback)
                  _buildCompactMenuItem(
                    context,
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context); // Close drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      );
                    },
                  ),

                  // 5. LOGOUT
                  _buildCompactMenuItem(
                    context,
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    isDestructive: true,
                    onTap: () async {
                      await Supabase.instance.client.auth.signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const AuthPage()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  // Helper for small, compact menu items
  Widget _buildCompactMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap,
      bool isDestructive = false}) {
    return ListTile(
      visualDensity: VisualDensity.compact, // Reduces height
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: Icon(icon,
          size: 22, color: isDestructive ? Colors.red : Colors.grey.shade700),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13, // Smaller font for compact width
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : Colors.grey.shade800,
        ),
      ),
      onTap: onTap,
    );
  }
}

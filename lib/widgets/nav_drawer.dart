import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:share_plus/share_plus.dart';

import '../pages/profile_page.dart';
import '../pages/progress_page.dart';
import '../pages/auth_page.dart';
import '../pages/settings_page.dart';
import '../pages/faq_page.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145,
      margin: const EdgeInsets.only(top: 65, bottom: 300, left: 10, right: 60),
      child: Drawer(
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.5)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildCompactMenuItem(
                    context,
                    icon: Icons.history_rounded,
                    title: 'History',
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ProgressPage()),
                    ),
                  ),
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
                  _buildCompactMenuItem(
                    context,
                    icon: Icons.help_outline_rounded,
                    title: 'FAQ',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FAQPage()),
                      );
                    },
                  ),
                  _buildCompactMenuItem(
                    context,
                    icon: Icons.share_rounded,
                    title: 'Share Saamay',
                    onTap: () {
                      Navigator.pop(context);
                      Share.share('Check out Saamay App for Quran recitation and analysis!');
                    },
                  ),
                  const Divider(indent: 20, endIndent: 20),
                  _buildCompactMenuItem(
                    context,
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      );
                    },
                  ),
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

  Widget _buildCompactMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap,
      bool isDestructive = false}) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: Icon(icon,
          size: 22, color: isDestructive ? Colors.red : Colors.grey.shade700),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : Colors.grey.shade800,
        ),
      ),
      onTap: onTap,
    );
  }
}

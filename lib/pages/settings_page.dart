import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import 'about_page.dart';
import 'feedback.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section 1: Appearance
          const _SectionHeader(title: "Appearance"),
          Card(
            elevation: 0,
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading:
                  const Icon(Icons.color_lens_outlined, color: Colors.green),
              title: const Text("App Theme"),
              subtitle: Text(_getThemeName(themeProvider.themeName)),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: themeProvider.themeName,
                  icon: Icon(Icons.arrow_drop_down,
                      color: isDark ? Colors.grey.shade400 : Colors.grey),
                  items: const [
                    DropdownMenuItem(value: "White", child: Text("Light")),
                    DropdownMenuItem(value: "Dark", child: Text("Dark")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      themeProvider.setTheme(value);
                    }
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Section 2: General
          const _SectionHeader(title: "General"),
          _buildSettingsItem(
            context,
            icon: Icons.info_outline_rounded,
            title: "About Saamay",
            subtitle: "Version 1.0.0",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutPage()),
            ),
          ),
          _buildSettingsItem(
            context,
            icon: Icons.feedback_outlined,
            title: "Send Feedback",
            subtitle: "Help us improve the app",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FeedbackForm()),
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeName(String key) {
    switch (key) {
      case "Dark":
        return "Dark Mode 🌙";
      default:
        return "Light Mode ☀️";
    }
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: Icon(Icons.arrow_forward_ios_rounded,
            size: 16, color: isDark ? Colors.grey.shade600 : Colors.grey),
        onTap: onTap,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/nav_drawer.dart';
import 'home_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("About Saamay")),
      appBar: AppBar(
        title: const Text("About"),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_double_arrow_left_outlined),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false, // clear all previous routes
            );
          },
        ),
      ),
      drawer: const NavDrawer(),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "Saamay helps you memorize, recite, and track your progress "
          "with Quran recitation using AI speech recognition and learning tools.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

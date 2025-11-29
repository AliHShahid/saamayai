import 'package:flutter/material.dart';
import '../widgets/nav_drawer.dart';
import 'home_page.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("History & Progress")),
      appBar: AppBar(
        title: const Text("History"),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // mock history
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.history),
              title: Text("Recitation attempt #$index"),
              subtitle: const Text("Accuracy: 85% • Date: 2025-10-14"),
            ),
          );
        },
      ),
    );
  }
}

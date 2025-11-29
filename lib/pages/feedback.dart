import 'package:flutter/material.dart';
import '../widgets/nav_drawer.dart';
import 'home_page.dart';

class FeedbackForm extends StatelessWidget {
  const FeedbackForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
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
          "Feedback"
          "Email us at feedback@saamay.io",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

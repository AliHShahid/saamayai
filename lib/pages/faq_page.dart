
import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQ"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          FAQItem(
            question: "How do I use the Recitation feature?",
            answer: "Navigate to a Surah, tap the microphone icon, and start reciting. The app will analyze your recitation in real-time.",
          ),
          FAQItem(
            question: "Can I use the app offline?",
            answer: "Currently, the recitation analysis requires an internet connection. Viewing the Quran text works offline once loaded.",
          ),
          FAQItem(
            question: "Is my progress saved?",
            answer: "Yes, if you are logged in, your progress is saved automatically to the cloud.",
          ),
          FAQItem(
            question: "How do I change the font size?",
            answer: "Currently, the font size is optimized for readability. We plan to add adjustable font settings in a future update.",
          ),
        ],
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: const TextStyle(
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

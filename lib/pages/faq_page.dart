import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final List<Map<String, String>> faqs = [
    {
      "q": "How do I use the Recitation feature?",
      "a": "Navigate to a Surah, tap the microphone icon, and start reciting. The app will analyze your recitation in real-time."
    },
    {
      "q": "Can I use the app offline?",
      "a": "Currently, the recitation analysis requires an internet connection. Viewing the Quran text works offline once loaded."
    },
    {
      "q": "Is my progress saved?",
      "a": "Yes, if you are logged in, your progress is saved automatically to the cloud."
    },
    {
      "q": "How do I change the font size?",
      "a": "Currently, the font size is optimized for readability. We plan to add adjustable font settings in a future update."
    },
    {
      "q": "What do the different colors mean during recitation?",
      "a": "Green indicates a correctly recited word. Red signifies a mistake. Grey with a line through it means the word was missed, and Orange represents an extra word that wasn't in the text."
    },
    {
      "q": "How accurate is the Saamay AI?",
      "a": "Saamay utilizes a highly advanced, fine-tuned Whisper AI model specifically trained on Arabic Quranic recitation to detect subtle pronunciation and tajweed errors."
    },
    {
      "q": "How can I check my past progress?",
      "a": "You can view a detailed chart of your recitation accuracy over time by interacting with the 'Progress' button in the side navigation drawer."
    },
  ];

  final List<ExpansionTileController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < faqs.length; i++) {
      _controllers.add(ExpansionTileController());
    }
  }

  void _handleExpansion(int index, bool isExpanded) {
    if (isExpanded) {
      // Close all other panels smoothly
      for (int i = 0; i < _controllers.length; i++) {
        if (i != index && _controllers[i].isExpanded) {
          _controllers[i].collapse();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: ExpansionTile(
              controller: _controllers[index],
              onExpansionChanged: (expanded) => _handleExpansion(index, expanded),
              shape: const Border(), // Remove default borders on ExpansionTile
              title: Text(
                faq["q"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      faq["a"]!,
                      style: const TextStyle(
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

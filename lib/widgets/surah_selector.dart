import 'package:flutter/material.dart';
import '../services/quran_service.dart';

class SurahSelector extends StatelessWidget {
  final int selectedSurahNumber;
  final Function(int surahNumber, String surahName, int totalVerses) onSurahSelected;

  const SurahSelector({
    super.key,
    required this.selectedSurahNumber,
    required this.onSurahSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 114,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // Try to jump to the selected index roughly
        controller: ScrollController(
          initialScrollOffset: (selectedSurahNumber - 1) * 100.0 > 0 
              ? (selectedSurahNumber - 1) * 100.0 
              : 0,
        ),
        itemBuilder: (context, index) {
          final surahNumber = index + 1;
          final surahName = QuranService.surahNames[index];
          final verseCount = QuranService.surahVerseCounts[index];
          final isSelected = surahNumber == selectedSurahNumber;

          return GestureDetector(
            onTap: () {
              onSurahSelected(surahNumber, surahName, verseCount);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1B4332) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: isSelected 
                    ? Border.all(color: const Color(0xFF1B4332)) 
                    : Border.all(color: Colors.transparent),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF1B4332).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? Colors.white : Colors.grey.shade300,
                    ),
                    child: Text(
                      "$surahNumber",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? const Color(0xFF1B4332) : Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    surahName,
                    style: TextStyle(
                      fontFamily: 'IndoPakFont', 
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

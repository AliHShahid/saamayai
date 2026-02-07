import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/quran_service.dart';

class SurahPicker extends StatefulWidget {
  final int selectedSurahNumber;
  final Function(int surahNumber, String surahName, int totalVerses) onSurahSelected;

  const SurahPicker({
    super.key,
    required this.selectedSurahNumber,
    required this.onSurahSelected,
  });

  @override
  State<SurahPicker> createState() => _SurahPickerState();
}

class _SurahPickerState extends State<SurahPicker> {
  String searchQuery = "";
  late List<int> filteredIndices;

  @override
  void initState() {
    super.initState();
    filteredIndices = List.generate(114, (index) => index);
  }

  void _filterSurahs(String query) {
    setState(() {
      searchQuery = query;
      filteredIndices = List.generate(114, (index) => index).where((index) {
        final name = QuranService.surahNames[index].toLowerCase();
        final number = (index + 1).toString();
        return name.contains(query.toLowerCase()) || number.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Text(
            "Select Surah",
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B4332),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: _filterSurahs,
              decoration: InputDecoration(
                hintText: "Search by name or number...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1B4332)),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: filteredIndices.length,
              itemBuilder: (context, i) {
                final index = filteredIndices[i];
                final surahNumber = index + 1;
                final surahName = QuranService.surahNames[index];
                final verseCount = QuranService.surahVerseCounts[index];
                final isSelected = surahNumber == widget.selectedSurahNumber;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: () {
                      widget.onSurahSelected(surahNumber, surahName, verseCount);
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    tileColor: isSelected ? const Color(0xFF1B4332).withOpacity(0.05) : Colors.transparent,
                    leading: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF1B4332) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "$surahNumber",
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      surahName,
                      style: GoogleFonts.outfit(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? const Color(0xFF1B4332) : Colors.black87,
                      ),
                    ),
                    subtitle: Text("$verseCount Verses"),
                    trailing: isSelected 
                      ? const Icon(Icons.check_circle, color: Color(0xFF1B4332))
                      : const Icon(Icons.chevron_right, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

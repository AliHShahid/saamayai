
import 'quran_service.dart';

class SurahPagination {
  /// Splits a list of Ayah numbers into pages based on word count.
  /// 
  /// [surahNumber]: The Surah number.
  /// [totalVerses]: Total number of verses in the Surah.
  /// [quranService]: Instance of QuranService to fetch text.
  /// [wordsPerPage]: Target words per page (default ~52).
  static List<List<int>> paginateSurah(
    int surahNumber, 
    int totalVerses, 
    QuranService quranService, {
    int wordsPerPage = 52,
  }) {
    List<List<int>> pages = [];
    List<int> currentPage = [];
    int currentWordCount = 0;
    
    // Page 1 has header + bismillah (for most Surahs), so reduce capacity
    // Surah 9 doesn't have Bismillah, so it has slightly more space than others on pg 1
    // let's say header takes ~20 words equivalent space?
    // Bismillah takes ~5 words space?
    // Let's approximate Page 1 capacity to ~30 words.
    double page1Capacity = surahNumber == 9 ? 40 : 30; 
    
    double currentLimit = page1Capacity;

    for (int i = 1; i <= totalVerses; i++) {
      final text = quranService.getAyahText(surahNumber, i);
      final wordCount = _countWords(text);

      // If adding this ayah exceeds limit significantly, start new page
      // But verify we have at least 1 ayah on the page
      if (currentPage.isNotEmpty && (currentWordCount + wordCount > currentLimit)) {
        pages.add(List.from(currentPage));
        currentPage = [];
        currentWordCount = 0;
        currentLimit = wordsPerPage.toDouble(); // All subsequent pages use standard limit
      }

      currentPage.add(i);
      currentWordCount += wordCount;
    }

    // Add final page
    if (currentPage.isNotEmpty) {
      pages.add(currentPage);
    }

    return pages;
  }

  static int _countWords(String text) {
    if (text.isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }
}


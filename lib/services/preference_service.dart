import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class PreferenceService {
  static const String _keyLastSurahNumber = 'last_surah_number';
  static const String _keyLastSurahName = 'last_surah_name';
  static const String _keyLastSurahVerses = 'last_surah_verses';

  /// Save the last visited Surah details
  Future<void> saveLastSurah(int number, String name, int totalVerses) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLastSurahNumber, number);
    await prefs.setString(_keyLastSurahName, name);
    await prefs.setInt(_keyLastSurahVerses, totalVerses);
  }

  /// Get the last visited Surah details.
  Future<Map<String, dynamic>> getLastSurah() async {
    final prefs = await SharedPreferences.getInstance();
    final number = prefs.getInt(_keyLastSurahNumber) ?? 1;
    final name = prefs.getString(_keyLastSurahName) ?? 'Al-Fatiha';
    final verses = prefs.getInt(_keyLastSurahVerses) ?? 6;

    return {
      'number': number,
      'name': name,
      'verses': verses,
    };
  }

  /// Save the last read Ayah for a specific Surah
  Future<void> saveSurahScrollPosition(int surahNumber, int lastAyah) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('surah_${surahNumber}_last_ayah', lastAyah);
  }

  /// Get the last read Ayah for a specific Surah
  Future<int> getSurahScrollPosition(int surahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('surah_${surahNumber}_last_ayah') ?? 1;
  }

  /// Save a transcription/recitation result to Supabase history
  Future<void> saveRecitationResult(int surah, String name, double accuracy) async {
    if (accuracy <= 0) return; // Don't save empty/useless attempts

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return; // Must be logged in

    try {
      await Supabase.instance.client.from('recitation_history').insert({
        'user_id': user.id,
        'surah_number': surah,
        'surah_name': name,
        'accuracy_score': accuracy,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint("❌ Error saving to Supabase: $e");
    }
  }

  /// Get all recitation history entries from Supabase
  Future<List<Map<String, dynamic>>> getHistory() async {
     try {
       final response = await Supabase.instance.client
           .from('recitation_history')
           .select()
           .order('created_at', ascending: false)
           .limit(50); // Limit to last 50 for now
       
       // Map to match the structure expected by UI if needed, or return raw
       // The UI expects: name, accuracy, date. 
       // Supabase returns: surah_name, accuracy_score, created_at
       return List<Map<String, dynamic>>.from(response).map((item) {
         return {
           'surah': item['surah_number'],
           'name': item['surah_name'],
           'accuracy': (item['accuracy_score'] as num?)?.toDouble() ?? 0.0,
           'date': item['created_at'],
         };
       }).toList();

    } catch (e) {
      debugPrint("❌ Error fetching history from Supabase: $e");
      return [];
    }
  }

  /// Calculates the current and longest streaks based on active days
  Future<Map<String, int>> getStreakStats() async {
    final history = await getHistory();
    if (history.isEmpty) return {'current': 0, 'longest': 0};

    final activeDates = <String>{};
    for (var item in history) {
      if (item['date'] != null) {
        try {
          final parsed = DateTime.parse(item['date'].toString()).toLocal();
          activeDates.add('${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}');
        } catch (_) {}
      }
    }

    if (activeDates.isEmpty) return {'current': 0, 'longest': 0};

    // Calculate current streak
    int currentStreak = 0;
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayStr = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';

    DateTime checkDate = today;
    if (!activeDates.contains(todayStr) && !activeDates.contains(yesterdayStr)) {
      currentStreak = 0;
    } else {
      if (!activeDates.contains(todayStr)) {
        checkDate = yesterday; // Streak continues from yesterday
      }
      while (true) {
        final dateStr = '${checkDate.year}-${checkDate.month.toString().padLeft(2, '0')}-${checkDate.day.toString().padLeft(2, '0')}';
        if (activeDates.contains(dateStr)) {
          currentStreak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      }
    }

    // Calculate longest streak
    int longest = 0;
    int currentRun = 0;
    // To do this simply over the available dates, we sort them
    final sortedDates = activeDates.map((s) => DateTime.parse(s)).toList()..sort((a, b) => a.compareTo(b));
    
    if (sortedDates.isNotEmpty) {
      currentRun = 1;
      longest = 1;
      for (int i = 1; i < sortedDates.length; i++) {
        final diff = sortedDates[i].difference(sortedDates[i - 1]).inDays;
        if (diff == 1) {
          currentRun++;
        } else if (diff > 1) {
          currentRun = 1;
        }
        if (currentRun > longest) {
          longest = currentRun;
        }
      }
    }

    return {'current': currentStreak, 'longest': longest};
  }
}

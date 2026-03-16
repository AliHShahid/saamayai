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
    final verses = prefs.getInt(_keyLastSurahVerses) ?? 7;

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
}

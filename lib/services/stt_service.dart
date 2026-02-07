import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class STTService {
  // ⚠️ YOUR STATIC DOMAIN from Ngrok
  // static const String baseUrl = "https://shayna-ungauged-complainingly.ngrok-free.dev";
  // static const String baseUrl = "https://alihassanshahid-whisper-fastapi.hf.space";
  static const String baseUrl = "https://alihassanshahid00--saamay-backend-fastapi-app.modal.run";

  static Future<Map<String, dynamic>> transcribe(String filePath, int surah) async {
    try {
      final uri = Uri.parse('$baseUrl/transcribe');
      final request = http.MultipartRequest('POST', uri);

      final mimeType = lookupMimeType(filePath) ?? 'audio/wav';
      final mimeTypeData = mimeType.split('/');
      
      request.files.add(await http.MultipartFile.fromPath(
        'file', 
        filePath,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ));

      request.fields['surah_number'] = surah.toString();
      // request.fields['ayah_number'] = ayah.toString(); // Removed since we are doing full surah streaming/checking

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("❌ Server Error: ${response.body}");
        return {"error": "Server Error", "status": "error"};
      }
    } catch (e) {
      print("❌ Network Error: $e");
      return {"error": "Connection Failed", "status": "error"};
    }
  }

  static Future<void> warmup() async {
    try {
      final uri = Uri.parse('$baseUrl/warmup');
      await http.get(uri);
    } catch (e) {
      print("❌ Warmup Error: $e");
    }
  }
}
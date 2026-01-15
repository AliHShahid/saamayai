// // // // // // import 'package:whisper_flutter_new/whisper_flutter_new.dart';

// // // // // // class STTService {
// // // // // //   late final Whisper _whisper;

// // // // // //   Future<void> initModel() async {
// // // // // //     _whisper = Whisper(
// // // // // //       model: WhisperModel.tiny,
// // // // // //       downloadHost: "https://huggingface.co/ggerganov/whisper.cpp/resolve/main",
// // // // // //     );
// // // // // //   }

// // // // // //   Future<String> transcribe(String audioPath) async {
// // // // // //     // Make sure the model is initialized
// // // // // //     if (_whisper == null) await initModel();

// // // // // //     final response = await _whisper.transcribe(
// // // // // //       transcribeRequest: TranscribeRequest(
// // // // // //         audio: audioPath,
// // // // // //         isTranslate: false,
// // // // // //       ),
// // // // // //     );

// // // // // //     return response.text; // ✅ extract string from response
// // // // // //   }
// // // // // // }

// // // // // import 'dart:convert';
// // // // // import 'dart:io';
// // // // // import 'package:http/http.dart' as http;

// // // // // class STTService {
// // // // //   static const String apiToken = "YOUR_HF_API_TOKEN";
// // // // //   static const String modelUrl =
// // // // //       "https://api-inference.huggingface.co/models/openai/whisper-tiny";

// // // // //   /// Transcribe audio file using Hugging Face Whisper Tiny
// // // // //   static Future<String> transcribe(String audioPath) async {
// // // // //     final bytes = await File(audioPath).readAsBytes();

// // // // //     final response = await http.post(
// // // // //       Uri.parse(modelUrl),
// // // // //       headers: {
// // // // //         "Authorization": "Bearer $apiToken",
// // // // //         "Content-Type": "audio/wav", // or audio/mpeg
// // // // //       },
// // // // //       body: bytes,
// // // // //     );

// // // // //     if (response.statusCode == 200) {
// // // // //       final data = jsonDecode(response.body);
// // // // //       return data['text'] ?? "";
// // // // //     } else {
// // // // //       print("HF API Error: ${response.statusCode} ${response.body}");
// // // // //       return "";
// // // // //     }
// // // // //   }
// // // // // }

// // // // // lib/services/stt_service.dart
// // // // import 'dart:convert';
// // // // import 'dart:io';
// // // // import 'package:http/http.dart' as http;

// // // // class STTService {
// // // //   // Replace with your Hugging Face API token
// // // //   static const String apiToken = "";
// // // //   static const String modelUrl =
// // // //       "https://api-inference.huggingface.co/models/openai/whisper-tiny";

// // // //   /// Transcribe audio file using Hugging Face Whisper Tiny
// // // //   static Future<String> transcribe(String audioPath) async {
// // // //     try {
// // // //       final bytes = await File(audioPath).readAsBytes();

// // // //       final response = await http.post(
// // // //         Uri.parse(modelUrl),
// // // //         headers: {
// // // //           "Authorization": "Bearer $apiToken",
// // // //           "Content-Type": "audio/wav",
// // // //         },
// // // //         body: bytes,
// // // //       );

// // // //       if (response.statusCode == 200) {
// // // //         final data = jsonDecode(response.body);
// // // //         return data['text'] ?? "";
// // // //       } else {
// // // //         print("HF API Error: ${response.statusCode} ${response.body}");
// // // //         return "Error: Unable to transcribe audio";
// // // //       }
// // // //     } catch (e) {
// // // //       print("STTService Error: $e");
// // // //       return "Error: $e";
// // // //     }
// // // //   }
// // // // }

// // // import 'dart:convert';
// // // import 'dart:io';
// // // import 'package:http/http.dart' as http;
// // // import 'package:mime/mime.dart';

// // // /// Change this to your ngrok HTTPS URL
// // // class APIConfig {
// // //   static const String baseUrl = "https://da409cd6cf89.ngrok-free.app";
// // // }

// // // class STTService {
// // //   /// Upload audio -> FastAPI -> Whisper -> Returns transcription
// // //   static Future<String> transcribe(String filePath) async {
// // //     try {
// // //       final url = Uri.parse("${APIConfig.baseUrl}/transcribe");

// // //       print("➡ Uploading audio file: $filePath");
// // //       print("➡ API Endpoint: $url");

// // //       final request = http.MultipartRequest("POST", url)
// // //         ..files.add(
// // //           await http.MultipartFile.fromPath(
// // //             "file",
// // //             filePath,
// // //           contentType: MediaType('audio', 'wav'),
// // //           ),
// // //         );

// // //       final response = await request.send();

// // //       // If backend errors out
// // //       if (response.statusCode != 200) {
// // //         final errorBody = await response.stream.bytesToString();
// // //         print("❌ Backend Error (${response.statusCode}): $errorBody");
// // //         return "Server error: ${response.statusCode}";
// // //       }

// // //       // Parse response body
// // //       final responseBody = await response.stream.bytesToString();
// // //       print("⬅ Response from backend: $responseBody");

// // //       final jsonBody = jsonDecode(responseBody);

// // //       // Ensure correct format
// // //       if (jsonBody.containsKey("transcription")) {
// // //         return jsonBody["transcription"];
// // //       }

// // //       return "No transcription found.";
// // //     } catch (e) {
// // //       print("❌ Exception while transcribing: $e");
// // //       return "Failed to transcribe audio.";
// // //     }
// // //   }
// // // }

// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:mime/mime.dart';
// // import 'package:http_parser/http_parser.dart';

// // /// Ngrok URL
// // class APIConfig {
// //   static const String baseUrl = "https://c8db57e9525a.ngrok-free.app";
// // }

// // class STTService {
// //   static Future<String> transcribe(String filePath) async {
// //     try {
// //       final url = Uri.parse("${APIConfig.baseUrl}/transcribe");

// //       print("➡ Uploading audio file: $filePath");
// //       print("➡ API Endpoint: $url");

// //       // Auto-detect MIME type
// //       final mimeType = lookupMimeType(filePath) ?? "audio/wav";
// //       final mimeParts = mimeType.split('/'); // ["audio", "mpeg"]

// //       print("➡ Detected MIME: $mimeType");

// //       final request = http.MultipartRequest("POST", url)
// //         ..files.add(
// //           await http.MultipartFile.fromPath(
// //             "file",
// //             filePath,
// //             contentType: MediaType(mimeParts[0], mimeParts[1]), // FIXED
// //           ),
// //         );

// //       final response = await request.send();

// //       if (response.statusCode != 200) {
// //         final errorBody = await response.stream.bytesToString();
// //         print("❌ Backend Error (${response.statusCode}): $errorBody");
// //         return "Server error: ${response.statusCode}";
// //       }

// //       final responseBody = await response.stream.bytesToString();
// //       print("⬅ Response from backend: $responseBody");

// //       final jsonBody = jsonDecode(responseBody);

// //       return jsonBody["transcription"] ?? "No transcription found.";
// //     } catch (e) {
// //       print("❌ Exception while transcribing: $e");
// //       return "Failed to transcribe audio.";
// //     }
// //   }
// // }

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:mime/mime.dart';
// import 'package:http_parser/http_parser.dart';

// /// Ngrok URL (Update this whenever you restart ngrok)
// class APIConfig {
//   static const String baseUrl = "https://shayna-ungauged-complainingly.ngrok-free.dev";
// }

// class STTService {
//   static Future<String> transcribe(String filePath) async {
//     try {
//       final url = Uri.parse("${APIConfig.baseUrl}/transcribe");

//       print("➡ Uploading audio file: $filePath");
//       print("➡ API Endpoint: $url");

//       // 1. Auto-detect MIME type (Default to audio/wav if detection fails)
//       final mimeType = lookupMimeType(filePath) ?? "audio/wav";
//       final mimeParts = mimeType.split('/'); // e.g. ["audio", "wav"]

//       // 2. Create the Multipart Request
//       final request = http.MultipartRequest("POST", url);

//       // 3. Add the file safely
//       final audioFile = await http.MultipartFile.fromPath(
//         "file", // This matches: file: UploadFile = File(...) in Python
//         filePath,
//         contentType: MediaType(mimeParts[0], mimeParts[1]),
//       );
//       request.files.add(audioFile);

//       // 4. Send with a timeout (e.g., 30 seconds for long audio)
//       final streamedResponse = await request.send().timeout(
//         const Duration(seconds: 30),
//         onTimeout: () {
//           throw Exception(
//               "Connection timed out. Check your internet or server.");
//         },
//       );

//       // 5. Parse the response
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         final jsonBody = jsonDecode(response.body);
//         final text = jsonBody["transcription"] ?? "No transcription returned.";
//         print("✅ Transcription: $text");
//         return text;
//       } else {
//         print("❌ Server Error (${response.statusCode}): ${response.body}");
//         return "Server Error: ${response.statusCode}\n${response.body}";
//       }
//     } catch (e) {
//       print("❌ Network Exception: $e");
//       return "Failed to connect: $e";
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class STTService {
  // ⚠️ Update this with your current Ngrok URL
  static const String baseUrl = "https://your-ngrok-url.ngrok-free.app";

  static Future<Map<String, dynamic>> transcribe(
      String filePath, int surahNumber) async {
    try {
      final uri = Uri.parse('$baseUrl/transcribe');
      final request = http.MultipartRequest('POST', uri);

      // 1. Add Audio File
      final mimeType = lookupMimeType(filePath) ?? 'audio/wav';
      final mimeTypeData = mimeType.split('/');

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        filePath,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ));

      // 2. Add Surah Number (for mistake detection)
      request.fields['surah_number'] = surahNumber.toString();

      // 3. Send Request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Return the full JSON response (which includes 'analysis')
        return jsonDecode(response.body);
      } else {
        return {
          "error": "Server Error: ${response.statusCode}",
          "details": response.body
        };
      }
    } catch (e) {
      return {"error": "Connection Failed", "details": e.toString()};
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'stt_service.dart'; // To reuse APIConfig.baseUrl

class SocketService {
  WebSocketChannel? _channel;
  
  // Stream for Transcriptions
  final StreamController<Map<String, dynamic>> _responseStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  
  Stream<Map<String, dynamic>> get responseStream => _responseStreamController.stream;

  /// Connect to WebSocket with Surah Number
  void connect(int surahNumber) {
    try {
      // Create WS URL from HTTP Base URL
      // Remove 'https://' and use 'wss://' (or 'ws://' if clean http)
      String baseUrl = STTService.baseUrl;
      String wsUrl = baseUrl.replaceFirst("https", "wss").replaceFirst("http", "ws");
      String finalUrl = "$wsUrl/ws/transcribe/$surahNumber";

      print("🔌 Connecting to WS: $finalUrl");

      _channel = WebSocketChannel.connect(Uri.parse(finalUrl));

      _channel!.stream.listen(
        (message) {
          try {
            print("📩 WS Received: $message");
            final data = jsonDecode(message);
            _responseStreamController.add(data);
          } catch (e) {
            print("❌ WS Parse Error: $e");
          }
        },
        onError: (error) => print("❌ WS Error: $error"),
        onDone: () => print("🔌 WS Closed"),
      );
    } catch (e) {
      print("❌ Connection failed: $e");
    }
  }

  void sendAudioChunk(Uint8List data) {
    if (_channel != null) {
      _channel!.sink.add(data);
    }
  }

  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close(status.goingAway);
      _channel = null;
    }
  }
}

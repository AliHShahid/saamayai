// import 'dart:async';
// import 'dart:typed_data';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as status;

// class SocketService {
//   WebSocketChannel? _channel;
//   final String _url = "wss://4964d286f410.ngrok-free.app/ws/transcribe";

//   final StreamController<String> _textStreamController =
//       StreamController<String>.broadcast();
//   Stream<String> get transcriptionStream => _textStreamController.stream;

//   void connect() {
//     try {
//       _channel = WebSocketChannel.connect(Uri.parse(_url));

//       // Listen for messages from server
//       _channel!.stream.listen(
//         (message) {
//           // Add the incoming text to our stream so the UI updates
//           _textStreamController.add(message);
//         },
//         onError: (error) => print("Socket Error: $error"),
//         onDone: () => print("Socket Closed"),
//       );
//     } catch (e) {
//       print("Connection failed: $e");
//     }
//   }

//   void sendAudioChunk(Uint8List data) {
//     if (_channel != null) {
//       _channel!.sink.add(data);
//     }
//   }

//   void disconnect() {
//     _channel?.sink.close(status.goingAway);
//   }
// }

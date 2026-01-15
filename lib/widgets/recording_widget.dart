// // // // import 'dart:io';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:record/record.dart';
// // // // import 'package:permission_handler/permission_handler.dart';
// // // // import '../services/stt_service.dart';

// // // // class RecordingWidget extends StatefulWidget {
// // // //   const RecordingWidget({super.key});

// // // //   @override
// // // //   State<RecordingWidget> createState() => _RecordingWidgetState();
// // // // }

// // // // class _RecordingWidgetState extends State<RecordingWidget> {
// // // //   // final recorder = Record();
// // // //   final AudioRecorder recorder = AudioRecorder();
// // // //   bool isRecording = false;
// // // //   String transcription = "";
// // // //   String? audioPath;

// // // //   // ------- 1. CHECK PERMISSION -------
// // // //   Future<bool> checkMicPermission() async {
// // // //     final status = await Permission.microphone.request();
// // // //     return status.isGranted;
// // // //   }

// // // //   // ------- 2. START RECORDING -------
// // // //   Future<void> startRecording() async {
// // // //     final hasPermission = await checkMicPermission();
// // // //     if (!hasPermission) {
// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         const SnackBar(content: Text("Microphone permission denied")),
// // // //       );
// // // //       return;
// // // //     }

// // // //     // Save audio in temporary directory (works for Android & iOS)
// // // //     final tempDir = Directory.systemTemp;
// // // //     audioPath = '${tempDir.path}/saamay_record.wav';

// // // //     await recorder.start(
// // // //       // path: audioPath!,
// // // //       // encoder: AudioEncoder.wav,
// // // //       const RecordConfig(),
// // // //       path: audioPath!,
// // // //     );

// // // //     setState(() => isRecording = true);
// // // //   }

// // // //   // ------- 3. STOP RECORDING -------
// // // //   Future<void> stopRecording() async {
// // // //     // await recorder.stop();
// // // //     final String? path = await recorder.stop();
// // // //     setState(() => isRecording = false);
// // // //     final filePath = path ?? audioPath;

// // // //     // if (audioPath != null && File(audioPath!).existsSync()) {
// // // //     if (filePath != null && File(filePath).existsSync()) {
// // // //       // Transcribe using Whisper Tiny
// // // //       // final text = await STTService.transcribe(audioPath!);
// // // //       // final sttService = STTService();
// // // //       final text = await STTService.transcribe(filePath);
// // // //       setState(() => transcription = text);
// // // //     }
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Card(
// // // //       elevation: 4,
// // // //       margin: const EdgeInsets.all(16),
// // // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// // // //       child: Padding(
// // // //         padding: const EdgeInsets.all(16.0),
// // // //         child: Column(
// // // //           children: [
// // // //             // ----- RECORD BUTTON -----
// // // //             IconButton(
// // // //               iconSize: 64,
// // // //               color: isRecording ? Colors.red : Colors.green,
// // // //               icon: Icon(isRecording ? Icons.stop : Icons.mic),
// // // //               onPressed: isRecording ? stopRecording : startRecording,
// // // //             ),

// // // //             const SizedBox(height: 16),

// // // //             // ----- STATUS -----
// // // //             Text(
// // // //               isRecording ? "Recording..." : "Tap to record",
// // // //               style: const TextStyle(fontSize: 18),
// // // //             ),

// // // //             const SizedBox(height: 16),

// // // //             // ----- TRANSCRIPTION -----
// // // //             if (transcription.isNotEmpty) ...[
// // // //               const Text(
// // // //                 "Transcription:",
// // // //                 style: TextStyle(fontWeight: FontWeight.bold),
// // // //               ),
// // // //               const SizedBox(height: 8),
// // // //               Text(
// // // //                 transcription,
// // // //                 style: const TextStyle(fontSize: 16),
// // // //               ),
// // // //             ]
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // import 'dart:io';
// // // import 'package:flutter/material.dart';
// // // import 'package:record/record.dart';
// // // import 'package:permission_handler/permission_handler.dart';
// // // import '../services/stt_service.dart';

// // // class RecordingWidget extends StatefulWidget {
// // //   const RecordingWidget({super.key});

// // //   @override
// // //   State<RecordingWidget> createState() => _RecordingWidgetState();
// // // }

// // // class _RecordingWidgetState extends State<RecordingWidget> {
// // //   final AudioRecorder recorder = AudioRecorder();
// // //   bool isRecording = false;
// // //   String transcription = "";
// // //   String? audioPath;

// // //   // Request microphone permission
// // //   Future<bool> checkMicPermission() async {
// // //     final status = await Permission.microphone.request();
// // //     return status.isGranted;
// // //   }

// // //   // ------------------ START RECORDING ------------------
// // //   Future<void> startRecording() async {
// // //     final hasPermission = await checkMicPermission();
// // //     if (!hasPermission) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(content: Text("Microphone permission denied")));
// // //       return;
// // //     }

// // //     // Save audio to temporary directory
// // //     final tempDir = Directory.systemTemp;
// // //     audioPath =
// // //         '${tempDir.path}/saamay_record_${DateTime.now().millisecondsSinceEpoch}.wav';

// // //     await recorder.start(
// // //       const RecordConfig(
// // //         encoder: AudioEncoder.wav,
// // //         sampleRate: 16000,
// // //         bitRate: 128000,
// // //       ),
// // //       path: audioPath!,
// // //     );

// // //     setState(() => isRecording = true);
// // //   }

// // //   // ------------------ STOP RECORDING ------------------
// // //   Future<void> stopRecording() async {
// // //     final recordedPath = await recorder.stop();
// // //     setState(() => isRecording = false);

// // //     final fileToSend = recordedPath ?? audioPath;

// // //     if (fileToSend != null && File(fileToSend).existsSync()) {
// // //       final text = await STTService.transcribe(fileToSend);
// // //       setState(() => transcription = text);
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Card(
// // //       elevation: 4,
// // //       margin: const EdgeInsets.all(16),
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: Column(
// // //           children: [
// // //             IconButton(
// // //               iconSize: 64,
// // //               color: isRecording ? Colors.red : Colors.green,
// // //               icon: Icon(isRecording ? Icons.stop : Icons.mic),
// // //               onPressed: isRecording ? stopRecording : startRecording,
// // //             ),
// // //             const SizedBox(height: 16),
// // //             Text(
// // //               isRecording ? "Recording..." : "Tap to record",
// // //               style: const TextStyle(fontSize: 18),
// // //             ),
// // //             const SizedBox(height: 16),
// // //             if (transcription.isNotEmpty) ...[
// // //               const Text(
// // //                 "Transcription:",
// // //                 style: TextStyle(fontWeight: FontWeight.bold),
// // //               ),
// // //               const SizedBox(height: 8),
// // //               Text(
// // //                 transcription,
// // //                 style: const TextStyle(fontSize: 16),
// // //               ),
// // //             ]
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }


// // // V2
// // import 'dart:async';
// // import 'dart:typed_data'; 
// // import 'package:flutter/material.dart';
// // import 'package:record/record.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import '../services/socket_service.dart';

// // class RecordingWidget extends StatefulWidget {
// //   const RecordingWidget({super.key});

// //   @override
// //   State<RecordingWidget> createState() => _RecordingWidgetState();
// // }

// // class _RecordingWidgetState extends State<RecordingWidget>
// //     with SingleTickerProviderStateMixin {
// //   // Audio Recorder & Socket Service
// //   final AudioRecorder recorder = AudioRecorder();
// //   final SocketService _socketService = SocketService();

// //   // State Variables
// //   bool isRecording = false;
// //   String transcription = "";
// //   StreamSubscription<List<int>>? _audioStreamSubscription;

// //   // Animation Controllers
// //   late AnimationController _animationController;
// //   late Animation<double> _scaleAnimation;

// //   @override
// //   void initState() {
// //     super.initState();

// //     // 1. Connect to WebSocket
// //     _socketService.connect();

// //     // 2. Listen for Live Transcriptions from Backend
// //     _socketService.transcriptionStream.listen((text) {
// //       if (mounted) {
// //         setState(() {
// //           transcription = text;
// //         });
// //       }
// //     });

// //     // 3. Setup Pulse Animation
// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 1500),
// //     )..repeat(reverse: true);

// //     _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
// //       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _animationController.dispose();
// //     _audioStreamSubscription?.cancel();
// //     _socketService.disconnect();
// //     recorder.dispose();
// //     super.dispose();
// //   }

// //   // ------------------ START LIVE RECORDING ------------------
// //   Future<void> startRecording() async {
// //     final status = await Permission.microphone.request();
// //     if (status != PermissionStatus.granted) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(content: Text("Microphone permission denied")));
// //       }
// //       return;
// //     }

// //     try {
// //       // Start the audio stream
// //       // Note: If 'pcm16bit' still gives an error, run 'flutter clean'
// //       // or change it to 'AudioEncoder.wav'
// //       final stream = await recorder.startStream(
// //         const RecordConfig(
// //           encoder: AudioEncoder.pcm16bits,
// //           sampleRate: 16000,
// //           numChannels: 1,
// //         ),
// //       );

// //       // Listen to microphone data and send to WebSocket
// //       _audioStreamSubscription = stream.listen((data) {
// //         _socketService.sendAudioChunk(Uint8List.fromList(data));
// //       });

// //       setState(() {
// //         isRecording = true;
// //         transcription = "Listening...";
// //       });
// //     } catch (e) {
// //       print("Error starting stream: $e");
// //     }
// //   }

// //   // ------------------ STOP LIVE RECORDING ------------------
// //   Future<void> stopRecording() async {
// //     await _audioStreamSubscription?.cancel();
// //     await recorder.stop();
// //     setState(() => isRecording = false);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         // ----- TRANSCRIPTION AREA -----
// //         Container(
// //           width: double.infinity,
// //           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(20),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.grey.withOpacity(0.1),
// //                 blurRadius: 10,
// //                 offset: const Offset(0, 5),
// //               ),
// //             ],
// //           ),
// //           child: Column(
// //             children: [
// //               // Header Text
// //               Text(
// //                 isRecording ? "Listening..." : "Ready to Recite?",
// //                 style: TextStyle(
// //                   fontSize: 22,
// //                   fontWeight: FontWeight.bold,
// //                   color: isRecording ? Colors.green : Colors.black87,
// //                 ),
// //               ),
// //               const SizedBox(height: 10),

// //               // Transcription Output
// //               Text(
// //                 transcription.isNotEmpty
// //                     ? transcription
// //                     : "Tap the microphone below to start reciting.",
// //                 textAlign: TextAlign.center,
// //                 style: TextStyle(
// //                   fontSize: 16,
// //                   height: 1.5,
// //                   color:
// //                       transcription.isNotEmpty ? Colors.black87 : Colors.grey,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),

// //         const SizedBox(height: 40),

// //         // ----- ANIMATED MIC BUTTON -----
// //         GestureDetector(
// //           onTap: isRecording ? stopRecording : startRecording,
// //           child: AnimatedBuilder(
// //             animation: _scaleAnimation,
// //             builder: (context, child) {
// //               return Stack(
// //                 alignment: Alignment.center,
// //                 children: [
// //                   // Ripple Effect (Visible when recording)
// //                   if (isRecording)
// //                     Container(
// //                       width: 80 * _scaleAnimation.value,
// //                       height: 80 * _scaleAnimation.value,
// //                       decoration: BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         color: Colors.green.withOpacity(0.2),
// //                       ),
// //                     ),

// //                   // Main Button
// //                   Container(
// //                     width: 70,
// //                     height: 70,
// //                     decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       // Green when idle, Red when recording
// //                       color: isRecording ? Colors.red : Colors.green,
// //                       boxShadow: [
// //                         BoxShadow(
// //                           color: (isRecording ? Colors.red : Colors.green)
// //                               .withOpacity(0.4),
// //                           blurRadius: 15,
// //                           offset: const Offset(0, 8),
// //                         ),
// //                       ],
// //                     ),
// //                     child: Icon(
// //                       isRecording ? Icons.stop : Icons.mic,
// //                       color: Colors.white,
// //                       size: 32,
// //                     ),
// //                   ),
// //                 ],
// //               );
// //             },
// //           ),
// //         ),

// //         const SizedBox(height: 16),

// //         Text(
// //           isRecording ? "Tap to Stop" : "Tap to Record",
// //           style: const TextStyle(
// //             color: Colors.grey,
// //             fontSize: 14,
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }


// // // V1
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:record/record.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../services/stt_service.dart';

// class RecordingWidget extends StatefulWidget {
//   const RecordingWidget({super.key});

//   @override
//   State<RecordingWidget> createState() => _RecordingWidgetState();
// }

// class _RecordingWidgetState extends State<RecordingWidget>
//     with SingleTickerProviderStateMixin {
//   final AudioRecorder recorder = AudioRecorder();
//   bool isRecording = false;
//   String transcription = "";
//   String? audioPath;

//   // Animation controller for the pulsing effect
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     )..repeat(reverse: true);

//     _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     recorder.dispose();
//     super.dispose();
//   }

//   // Request microphone permission
//   Future<bool> checkMicPermission() async {
//     final status = await Permission.microphone.request();
//     return status.isGranted;
//   }

//   // ------------------ START RECORDING ------------------
//   Future<void> startRecording() async {
//     final hasPermission = await checkMicPermission();
//     if (!hasPermission) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Microphone permission denied")));
//       }
//       return;
//     }

//     // Save audio to temporary directory
//     final tempDir = Directory.systemTemp;
//     audioPath =
//         '${tempDir.path}/saamay_record_${DateTime.now().millisecondsSinceEpoch}.wav';

//     await recorder.start(
//       const RecordConfig(
//         encoder: AudioEncoder.wav,
//         sampleRate: 16000,
//         bitRate: 128000,
//       ),
//       path: audioPath!,
//     );

//     setState(() {
//       isRecording = true;
//       transcription = ""; // Clear previous transcription
//     });
//   }

//   // ------------------ STOP RECORDING ------------------
//   Future<void> stopRecording() async {
//     final recordedPath = await recorder.stop();
//     setState(() => isRecording = false);

//     final fileToSend = recordedPath ?? audioPath;

//     if (fileToSend != null && File(fileToSend).existsSync()) {
//       // Show a loading state if needed
//       setState(() => transcription = "Transcribing...");

//       final text = await STTService.transcribe(fileToSend);

//       if (mounted) {
//         setState(() => transcription = text);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // ----- TRANSCRIPTION AREA -----
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               // Header Text
//               Text(
//                 isRecording ? "Listening..." : "Ready to Recite?",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: isRecording ? Colors.green : Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // Transcription or Placeholder
//               Text(
//                 transcription.isNotEmpty
//                     ? transcription
//                     : "Tap the microphone below to start reciting your Quran lesson.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   height: 1.5,
//                   color:
//                       transcription.isNotEmpty ? Colors.black87 : Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         ),

//         const SizedBox(height: 40),

//         // ----- MICROPHONE BUTTON -----
//         GestureDetector(
//           onTap: isRecording ? stopRecording : startRecording,
//           child: AnimatedBuilder(
//             animation: _scaleAnimation,
//             builder: (context, child) {
//               return Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   // Ripple Effect (only visible when recording)
//                   if (isRecording)
//                     Container(
//                       width: 80 * _scaleAnimation.value,
//                       height: 80 * _scaleAnimation.value,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.green.withOpacity(0.2),
//                       ),
//                     ),

//                   // Main Button
//                   Container(
//                     width: 70,
//                     height: 70,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: isRecording
//                           ? Colors.red
//                           : Colors.green, // Green default, Red when active
//                       boxShadow: [
//                         BoxShadow(
//                           color: (isRecording ? Colors.red : Colors.green)
//                               .withOpacity(0.4),
//                           blurRadius: 15,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       isRecording ? Icons.stop : Icons.mic,
//                       color: Colors.white,
//                       size: 32,
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),

//         const SizedBox(height: 16),

//         Text(
//           isRecording ? "Tap to Stop" : "Tap to Record",
//           style: const TextStyle(
//             color: Colors.grey,
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/stt_service.dart';

class RecordingWidget extends StatefulWidget {
  final int surahNumber;
  final Function(Map<String, dynamic>) onAnalysisComplete; // Callback

  const RecordingWidget({
    super.key, 
    required this.surahNumber,
    required this.onAnalysisComplete,
  });

  @override
  State<RecordingWidget> createState() => _RecordingWidgetState();
}

class _RecordingWidgetState extends State<RecordingWidget> with SingleTickerProviderStateMixin {
  final AudioRecorder recorder = AudioRecorder();
  bool isRecording = false;
  bool isProcessing = false;
  String? audioPath;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    recorder.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) return;

    final tempDir = Directory.systemTemp;
    audioPath = '${tempDir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.wav';

    await recorder.start(
      const RecordConfig(encoder: AudioEncoder.wav),
      path: audioPath!,
    );

    setState(() => isRecording = true);
  }

  Future<void> stopRecording() async {
    final path = await recorder.stop();
    setState(() {
      isRecording = false;
      isProcessing = true; // Show loading
    });

    final fileToSend = path ?? audioPath;

    if (fileToSend != null && File(fileToSend).existsSync()) {
      // Call updated STT Service
      final result = await STTService.transcribe(fileToSend, widget.surahNumber);
      
      // Pass result up to SurahPage
      widget.onAnalysisComplete(result);
    }

    if (mounted) {
      setState(() => isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isProcessing)
            const Column(
              children: [
                CircularProgressIndicator(color: Colors.green),
                SizedBox(height: 10),
                Text("Analyzing Recitation...", style: TextStyle(color: Colors.grey)),
              ],
            )
          else
            GestureDetector(
              onTap: isRecording ? stopRecording : startRecording,
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      if (isRecording)
                        Container(
                          width: 80 * _scaleAnimation.value,
                          height: 80 * _scaleAnimation.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.withOpacity(0.2),
                          ),
                        ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isRecording ? Colors.red : Colors.green,
                          boxShadow: [
                            BoxShadow(
                              color: (isRecording ? Colors.red : Colors.green).withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Icon(
                          isRecording ? Icons.stop : Icons.mic,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          const SizedBox(height: 10),
          Text(
            isRecording ? "Tap to Stop" : "Tap to Recite",
            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
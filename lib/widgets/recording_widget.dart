import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/socket_service.dart';
import '../services/stt_service.dart';

class RecordingWidget extends StatefulWidget {
  final int surahNumber;
  final Function(Map<String, dynamic>) onAnalysisComplete;
  final VoidCallback? onRecordingStopped;

  const RecordingWidget({
    super.key,
    required this.surahNumber,
    required this.onAnalysisComplete,
    this.onRecordingStopped,
  });

  @override
  State<RecordingWidget> createState() => _RecordingWidgetState();
}

class _RecordingWidgetState extends State<RecordingWidget> with SingleTickerProviderStateMixin {
  final AudioRecorder recorder = AudioRecorder();
  final SocketService _socketService = SocketService();

  bool isRecording = false;
  bool isWarmingUp = false;
  static bool isModelLoaded = false;

  StreamSubscription? _audioStreamSubscription;
  StreamSubscription? _socketSubscription;

  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _socketSubscription = _socketService.responseStream.listen((data) {
      widget.onAnalysisComplete(data);
    });
  }

  @override
  void didUpdateWidget(RecordingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.surahNumber != oldWidget.surahNumber && isRecording) {
      // Reconnect to new Surah socket
      // Note: This interrupts the stream briefly.
      // Ideally we would have a seamless way, but for now reconnect is safest.
      _reconnectSocket();
    }
  }

  Future<void> _reconnectSocket() async {
    _socketService.disconnect();
    // Small delay to ensure disconnect
    await Future.delayed(const Duration(milliseconds: 100));
    _socketService.connect(widget.surahNumber);
  }
  @override
  void dispose() {
    _animationController.dispose();
    _socketSubscription?.cancel();
    _audioStreamSubscription?.cancel();
    _socketService.disconnect();
    recorder.dispose();
    super.dispose();
  }

  Future<void> handleTap() async {
    if (isRecording) {
      await stopRecording();
    } else {
      await startRecordingFlow();
    }
  }

  Future<void> startRecordingFlow() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) return;

    // We no longer block here. 
    // Warmup is triggered in SurahPage. Even if it's not done, 
    // we let the user record. The first chunk might be slightly slower,
    // but the UI interaction is instant.
    await startRecording();
  }

  Future<void> startRecording() async {
    _socketService.connect(widget.surahNumber);
    final stream = await recorder.startStream(
      const RecordConfig(
          encoder: AudioEncoder.pcm16bits, sampleRate: 16000, numChannels: 1),
    );

    _audioStreamSubscription = stream.listen((data) {
      _socketService.sendAudioChunk(Uint8List.fromList(data));
    });

    setState(() {
      isRecording = true;
    });
  }

  Future<void> stopRecording() async {
    await _audioStreamSubscription?.cancel();
    await recorder.stop();
    _socketService.disconnect();

    if (mounted) {
      setState(() {
        isRecording = false;
      });
      widget.onRecordingStopped?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF50D392);
    
    // Pulse effect only when active (Recording or Warming Up)
    bool isActive = isRecording || isWarmingUp;

    return GestureDetector(
      onTap: isWarmingUp ? null : handleTap,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            width: 70,
            // width: double.infinity,
            // height: 80,     
            height: 70,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(0),
              shape: BoxShape.circle,
              color: Colors.white,
              // Shadow provides the "Glow"
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: neonGreen.withValues(alpha: 0.5 * _glowAnimation.value),
                        blurRadius: 15 * _glowAnimation.value,
                        spreadRadius: 2 * _glowAnimation.value,
                      ),
                    ]
                  : [
                      // Subtle shadow when idle
                      BoxShadow( 
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
            ),
            child: Center(
              child: _buildIconState(neonGreen),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconState(Color iconColor) {
    if (isWarmingUp) {
      return SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          color: iconColor,
          strokeWidth: 3,
        ),
      );
    }
    
    if (isRecording) {
      return Icon(
        Icons.stop_rounded,
        color: iconColor,
        size: 38,
      );
    }

    return Icon(
      Icons.mic_rounded,
      color: iconColor,
      size: 38,
    );
  }
}

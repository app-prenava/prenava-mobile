import 'dart:typed_data';
import 'voice_recorder_interface.dart';

class PlatformVoiceRecorder implements AppVoiceRecorder {
  @override
  bool get isRecording => false;

  @override
  Future<bool> start() async => false;

  @override
  Future<Uint8List?> stop() async => null;

  @override
  void cancel() {}
}

AppVoiceRecorder createVoiceRecorder() => PlatformVoiceRecorder();

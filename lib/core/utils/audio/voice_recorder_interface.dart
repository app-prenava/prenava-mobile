import 'dart:typed_data';

abstract class AppVoiceRecorder {
  bool get isRecording;
  Future<bool> start();
  Future<Uint8List?> stop();
  void cancel();
}

import 'voice_recorder_interface.dart';
import 'voice_recorder_stub.dart'
    if (dart.library.html) 'voice_recorder_web.dart';

class VoiceRecorderService {
  final AppVoiceRecorder _recorder = createVoiceRecorder();

  bool get isRecording => _recorder.isRecording;

  Future<bool> startRecording() => _recorder.start();

  Future<List<int>?> stopRecording() async {
    final bytes = await _recorder.stop();
    return bytes?.toList();
  }

  void cancelRecording() => _recorder.cancel();
}

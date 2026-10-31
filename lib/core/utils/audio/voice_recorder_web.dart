// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'voice_recorder_interface.dart';

class PlatformVoiceRecorder implements AppVoiceRecorder {
  html.MediaStream? _stream;
  html.MediaRecorder? _recorder;
  final List<html.Blob> _chunks = [];
  bool _isRecording = false;

  @override
  bool get isRecording => _isRecording;

  @override
  Future<bool> start() async {
    try {
      _chunks.clear();
      final mediaDevices = html.window.navigator.mediaDevices;
      if (mediaDevices == null) return false;

      _stream = await mediaDevices.getUserMedia({'audio': true});
      if (_stream == null) return false;

      _recorder = html.MediaRecorder(_stream!);
      _recorder!.addEventListener('dataavailable', (event) {
        final blobEvent = event as html.BlobEvent;
        if (blobEvent.data != null && (blobEvent.data?.size ?? 0) > 0) {
          _chunks.add(blobEvent.data!);
        }
      });

      _recorder!.start();
      _isRecording = true;
      return true;
    } catch (_) {
      _isRecording = false;
      return false;
    }
  }

  @override
  Future<Uint8List?> stop() async {
    if (!_isRecording || _recorder == null) return null;

    final completer = Completer<Uint8List?>();

    _recorder!.addEventListener('stop', (event) async {
      _isRecording = false;
      _stream?.getTracks().forEach((track) => track.stop());

      if (_chunks.isEmpty) {
        if (!completer.isCompleted) completer.complete(null);
        return;
      }

      final blob = html.Blob(_chunks, 'audio/webm');
      final reader = html.FileReader();
      reader.readAsArrayBuffer(blob);
      reader.onLoadEnd.listen((_) {
        final result = reader.result;
        if (result is Uint8List) {
          if (!completer.isCompleted) completer.complete(result);
        } else if (result is ByteBuffer) {
          if (!completer.isCompleted) completer.complete(result.asUint8List());
        } else {
          if (!completer.isCompleted) completer.complete(null);
        }
      });
    });

    _recorder!.stop();
    return completer.future;
  }

  @override
  void cancel() {
    _isRecording = false;
    try {
      _recorder?.stop();
    } catch (_) {}
    _stream?.getTracks().forEach((track) => track.stop());
    _chunks.clear();
  }
}

AppVoiceRecorder createVoiceRecorder() => PlatformVoiceRecorder();

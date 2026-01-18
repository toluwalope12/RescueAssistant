
import 'package:flutter/material.dart';
import 'package:record/record.dart'; // Modern recording
import 'package:path_provider/path_provider.dart';

class VoicePipelineService extends ChangeNotifier {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool get isRecording => _isRecording;

  Future<void> startRecording() async {
    if (await _recorder.hasPermission()) {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/user_voice.wav';
      
      // Configured for Gemini/AI STT compatibility
      await _recorder.start(const RecordConfig(encoder: AudioEncoder.wav), path: path);
      _isRecording = true;
      notifyListeners();
    }
  }

  Future<String?> stopRecording() async {
    final path = await _recorder.stop();
    _isRecording = false;
    notifyListeners();
    return path;
  }
}
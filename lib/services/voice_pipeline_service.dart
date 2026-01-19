import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class VoicePipelineService extends ChangeNotifier {
  final AudioRecorder _recorder = AudioRecorder();

  Future<void> startRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        // Saving as .wav for best Gemini compatibility in 2026
        final String filePath = '${dir.path}/emergency_audio.wav';
        
        const config = RecordConfig(
          encoder: AudioEncoder.wav, 
          bitRate: 128000,
          sampleRate: 44100,
        );

        await _recorder.start(config, path: filePath);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Recording Start Error: $e");
    }
  }

  Future<String?> stopRecording() async {
    try {
      // Returns the path directly to the UI
      final path = await _recorder.stop();
      return path; 
    } catch (e) {
      debugPrint("Recording Stop Error: $e");
      return null;
    }
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }
}
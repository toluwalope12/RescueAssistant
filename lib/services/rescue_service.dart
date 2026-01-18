import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

class RescueService extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _systemTts = FlutterTts();

  // Your Verified Credentials
  final String elevenKey = "sk_09cc5e7e4223abad5ed1f2b6404e770bce7b2e69e81ab15d";
  final String voiceId = "LJt5vLQsVQyLRcWKLzPD";

  Future<void> speak(String text) async {
    final url = Uri.parse("https://api.elevenlabs.io/v1/text-to-speech/$voiceId");

    try {
      final response = await http.post(
        url,
        headers: {
          "xi-api-key": elevenKey,
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "text": text,
          "model_id": "eleven_turbo_v2_5",
          "voice_settings": {
            "stability": 0.8,
            "similarity_boost": 0.7,
            "style": 0.0,
            "use_speaker_boost": true
          }
        }),
      );

      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/rescue_voice.mp3');
        await file.writeAsBytes(response.bodyBytes);
        await _audioPlayer.play(DeviceFileSource(file.path));
        print("ElevenLabs playing successfully!");
      } else {
        print("ElevenLabs Error: ${response.body}");
        await _systemTts.speak(text);
      }
    } catch (e) {
      print("System Error: $e");
      await _systemTts.speak(text);
    }
  }
}
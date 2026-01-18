import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get elevenLabsApiKey =>
      dotenv.env['ELEVENLABS_API_KEY'] ?? '';

  static String get elevenLabsVoiceId =>
      dotenv.env['ELEVENLABS_VOICE_ID'] ?? '';

  static String get geminiApiKey =>
      dotenv.env['GEMINI_API_KEY'] ?? '';
}

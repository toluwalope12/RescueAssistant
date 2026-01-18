// File: lib/utils/api_keys.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  static String get elevenLabsApiKey => dotenv.env['ELEVENLABS_API_KEY'] ?? '';
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
}

import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  late final GenerativeModel model;

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";
    
    // Using Gemini 3 Flash for maximum speed and 2026-grade accuracy
    model = GenerativeModel(
      model: 'gemini-3-flash-preview', 
      apiKey: apiKey,
      // System instructions act as a permanent brain for the AI
      systemInstruction: Content.system("""
        You are a professional Medical Emergency Dispatcher. 
        Analyze ONLY the audio provided in the CURRENT request. 
        Ignore all previous context or injuries.
        If the user is choking: Give Heimlich maneuver steps.
        If the user has a broken bone: Tell them to immobilize it.
        Be concise (under 40 words) and direct.
      """),
      safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
      ],
    );
  }

  Future<String> analyzeEmergency(String audioPath) async {
    try {
      final audioBytes = await File(audioPath).readAsBytes();
      
      // We wrap the audio in a fresh Content object to ensure zero carry-over
      final content = [
        Content.multi([
          DataPart('audio/wav', audioBytes),
          TextPart("Analyze this specific audio and provide immediate life-saving steps.")
        ])
      ];

      final response = await model.generateContent(content)
          .timeout(const Duration(seconds: 15)); // Faster timeout for Flash

      String result = response.text?.replaceAll('*', '') ?? "";
      
      if (result.isEmpty) throw Exception("Empty Response");
      return result;

    } catch (e) {
      print("Emergency AI Error: $e");
      // Generic safety fallback - NO specific injury mentioned
      return "I'm having trouble hearing the audio. Please stay calm, check the person's airway, and call emergency services immediately.";
    }
  }
}
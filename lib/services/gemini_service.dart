import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // Verified Key - No leading/trailing spaces
  static const String _apiKey = "AIzaSyCpiqnw235a7l8DRQMdfzimS4dJHditAO8"; 
  
  final model = GenerativeModel(
    model: 'gemini-2.5-flash', 
    apiKey: _apiKey, 
  );

  Future<String> analyzeEmergency(String audioPath) async {
    try {
      final audioFile = File(audioPath);
      if (!await audioFile.exists()) return "Error: Audio file not found.";
      
      final audioBytes = await audioFile.readAsBytes();
      
      final prompt = [
        Content.multi([
          TextPart("""You are an emergency medical responder. 
          Listen to the user's voice and identify the crisis.
          Give exactly 3 clear, life-saving steps.
          Keep it under 40 words total. Be calm."""),
          DataPart('audio/wav', audioBytes),
        ])
      ];

      final response = await model.generateContent(prompt);
      
      // Use the same logic we saw in the terminal test
      return response.text ?? "I'm here. Stay calm and tell me what happened.";
    } catch (e) {
      print("APP GEMINI ERROR: $e");
      return "Connection hiccup. Please check the person's breathing immediately.";
    }
  }
}
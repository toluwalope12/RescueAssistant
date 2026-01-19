import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive/hive.dart';
import '../models/history_entry.dart';
import '../services/voice_pipeline_service.dart';
import '../services/rescue_service.dart';
import '../services/gemini_service.dart';

class RescueAssistantScreen extends StatefulWidget {
  const RescueAssistantScreen({super.key});

  @override
  State<RescueAssistantScreen> createState() => _RescueAssistantScreenState();
}

class _RescueAssistantScreenState extends State<RescueAssistantScreen> {
  bool isAnalyzing = false;
  bool _isRecording = false; // Tracks if user is currently holding the button
  String displayInstructions = "Hold the button to explain your emergency.";

  // Sends the current instruction via SMS to emergency contacts
  Future<void> _sendSmartSOS() async {
    String contextMessage = displayInstructions.contains("Hold") 
        ? "EMERGENCY: I need immediate assistance." 
        : "EMERGENCY: I need help with: $displayInstructions";

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: '', 
      queryParameters: <String, String>{
        'body': contextMessage,
      },
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Accessing services via Provider
    final voiceService = Provider.of<VoicePipelineService>(context);
    final rescueService = Provider.of<RescueService>(context, listen: false);
    final geminiService = GeminiService();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // SOS Quick Trigger Header
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.emergency, color: Colors.redAccent, size: 30),
                  onPressed: _sendSmartSOS,
                ),
              ),

              const Icon(Icons.emergency_share, color: Colors.redAccent, size: 50),
              const SizedBox(height: 15),
              const Text(
                "RESCUE AI",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2),
              ),
              const SizedBox(height: 20),

              // AI Output Display Box
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 120),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: _isRecording ? Colors.redAccent : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Text(
                  displayInstructions,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      color: (_isRecording || isAnalyzing) ? Colors.redAccent : Colors.white70,
                      height: 1.4,
                      fontWeight: (_isRecording || isAnalyzing) ? FontWeight.bold : FontWeight.normal),
                ),
              ),

              const SizedBox(height: 20),

              // Analysis Progress Indicator
              SizedBox(
                height: 50, 
                child: isAnalyzing
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.redAccent,
                          strokeWidth: 4,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 20),

              // WHATSAPP-STYLE HOLD TO RECORD BUTTON
              GestureDetector(
                onLongPressStart: (_) async {
                  // Vibrate and start recording
                  HapticFeedback.heavyImpact(); 
                  setState(() {
                    _isRecording = true;
                    displayInstructions = "Recording... Release to get help.";
                  });
                  await voiceService.startRecording();
                },
                onLongPressEnd: (_) async {
                  // Vibrate and stop recording
                  HapticFeedback.mediumImpact();
                  setState(() {
                    _isRecording = false;
                    isAnalyzing = true;
                    displayInstructions = "Analyzing emergency audio...";
                  });

                  String? path = await voiceService.stopRecording();
                  
                  if (path != null) {
                    // Send to Gemini AI for Analysis
                    String instructions = await geminiService.analyzeEmergency(path);
                    
                    if (mounted) {
                      setState(() {
                        displayInstructions = instructions;
                        isAnalyzing = false;
                      });
                    }

                    // Convert AI Response to Voice via ElevenLabs
                    await rescueService.speak(instructions);

                    // Save to Local History
                    try {
                      final historyEntry = HistoryEntry(
                        timestamp: DateTime.now(),
                        transcription: "Voice SOS", 
                        responseText: instructions,
                      );
                      var box = Hive.box<HistoryEntry>('history');
                      await box.add(historyEntry);
                    } catch (e) {
                      debugPrint("History Save Error: $e");
                    }
                  } else {
                    setState(() {
                      isAnalyzing = false;
                      displayInstructions = "Audio capture failed. Please try again.";
                    });
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: EdgeInsets.all(_isRecording ? 45 : 35),
                  decoration: BoxDecoration(
                    color: _isRecording ? Colors.red : Colors.red[900],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _isRecording
                            ? Colors.red.withValues(alpha: 0.6)
                            : Colors.black.withValues(alpha: 0.4),
                        blurRadius: _isRecording ? 50 : 30,
                        spreadRadius: _isRecording ? 10 : 5,
                      )
                    ],
                  ),
                  child: Icon(
                    _isRecording ? Icons.mic : Icons.mic_none,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              
              const SizedBox(height: 25),
              Text(
                _isRecording ? "RELEASE TO SEND" : "HOLD TO RECORD",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white24,
                ),
              ),
              const SizedBox(height: 40), 
            ],
          ),
        ),
      ),
    );
  }
}
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
  bool _isManualRecording = false;
  String displayInstructions = "Welcome, please tap the button to explain your emergency.";

  Future<void> _sendSmartSOS() async {
    String contextMessage = displayInstructions.contains("Welcome") 
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

              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 120),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  // FIXED: Updated withOpacity to withValues(alpha: ...)
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: _isManualRecording ? Colors.redAccent : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Text(
                  displayInstructions,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      color: (isAnalyzing || _isManualRecording) ? Colors.redAccent : Colors.white70,
                      height: 1.4,
                      fontWeight: (isAnalyzing || _isManualRecording) ? FontWeight.bold : FontWeight.normal),
                ),
              ),

              const SizedBox(height: 20),

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

              GestureDetector(
                onTap: () async {
                  if (!_isManualRecording) {
                    HapticFeedback.heavyImpact(); 
                    setState(() {
                      _isManualRecording = true;
                      displayInstructions = "Listening... Tap again when finished.";
                    });
                    voiceService.startRecording();
                  } else {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      _isManualRecording = false;
                      isAnalyzing = true;
                      displayInstructions = "Analyzing emergency...";
                    });

                    String? path = await voiceService.stopRecording();
                    if (path != null) {
                      String instructions = await geminiService.analyzeEmergency(path);
                      
                      if (mounted) {
                        setState(() {
                          displayInstructions = instructions;
                          isAnalyzing = false;
                        });
                      }

                      await rescueService.speak(instructions);

                      try {
                        final historyEntry = HistoryEntry(
                          timestamp: DateTime.now(),
                          transcription: "Voice Input", 
                          responseText: instructions,
                        );
                        var box = Hive.box<HistoryEntry>('history');
                        await box.add(historyEntry);
                      } catch (e) {
                        debugPrint("History Save Error: $e");
                      }
                    }
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    color: _isManualRecording ? Colors.red : Colors.red[900],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        // FIXED: Updated withOpacity to withValues(alpha: ...)
                        color: _isManualRecording
                            ? Colors.red.withValues(alpha: 0.4)
                            : Colors.black.withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: Icon(
                    _isManualRecording ? Icons.stop : Icons.mic,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "TAP TO SPEAK",
                style: TextStyle(
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
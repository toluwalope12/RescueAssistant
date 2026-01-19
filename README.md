# 🚨 Rescue AI Assistant (2026 Hackathon Edition)

An ultra-fast, voice-first emergency response app powered by **Gemini 3 Flash** and **ElevenLabs**. Designed for high-stress situations where every second counts.

## 🚀 Key Features
- **WhatsApp-Style Interface:** Familiar long-press to record interaction.
- **Gemini 3 Flash Integration:** Real-time multimodal analysis of emergency audio (choking, bleeding, fire, etc.).
- **Life-Saving Audio Guidance:** Instant, professional first-aid instructions delivered via **ElevenLabs TTS**.
- **Privacy First:** Emergency audio is processed and immediately shredded (deleted) from the device.

## 🛠️ Tech Stack
- **Framework:** Flutter (3.x)
- **AI Model:** Gemini 3 Flash (Multimodal Audio-to-Text)
- **Voice:** ElevenLabs API
- **Local Database:** Hive (Emergency History)

## 🏃‍♂️ How to Run
1. Clone the repo.
2. Add your `GEMINI_API_KEY` and `ELEVENLABS_API_KEY` to the `.env` file.
3. Run `flutter pub get`.
4. Run `flutter run`.

## 🛡️ Safety Note
This is a hackathon prototype. In a real emergency, always prioritize calling local emergency services (911/112/999).
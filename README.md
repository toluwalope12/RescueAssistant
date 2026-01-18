# Rescue AI Assistant 🚑 🎙️

**A Voice-First Emergency Response Tool built for the ElevenLabs Hackathon.**

Rescue AI is designed for high-stress medical emergencies where typing is impossible. It uses **ElevenLabs'** high-fidelity voice synthesis to provide calm, audible guidance to responders, ensuring they can keep their hands on the patient and their eyes on the situation.

## 🚀 The ElevenLabs Advantage
In a crisis, people experience "tunnel vision" and struggle to read text. We integrated **ElevenLabs** to:
* **Reduce Cognitive Load:** Audible instructions allow hands-free first aid.
* **Calm the Responder:** A professional, human-like voice reduces bystander panic.
* **Contextual SOS:** The AI analyzes the injury and generates a specific SMS for emergency contacts.

## 🛠️ Tech Stack
* **Voice AI:** ElevenLabs (Text-to-Speech)
* **Reasoning:** Google Gemini API
* **Framework:** Flutter (Dart)
* **Local Storage:** Hive (Offline-first history and settings)

## 📦 How to Run
1. Clone the repo.
2. Add a `.env` file with your `GEMINI_API_KEY` and `ELEVEN_LABS_API_KEY`.
3. Run `flutter pub get`.
4. Run `dart run build_runner build --delete-conflicting-outputs`.
5. Run `flutter run`.
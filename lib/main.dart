import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/rescue_service.dart';
import 'services/voice_pipeline_service.dart';
import 'screens/main_navigation_wrapper.dart'; // This is the only import needed for the home page
import 'models/history_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Load Environment Variables
  await dotenv.load(fileName: ".env");

  // 2. Initialize Hive for Flutter
  await Hive.initFlutter();

  // 3. Register the Adapter
  Hive.registerAdapter(HistoryEntryAdapter());

  // 4. Open the Box
  await Hive.openBox<HistoryEntry>('history');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RescueService()),
        ChangeNotifierProvider(create: (_) => VoicePipelineService()),
      ],
      // Added 'const' here to satisfy the performance warning
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rescue Assistant',
      theme: ThemeData(
        primarySwatch: Colors.red, 
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
      ),
      // Fixed: Use 'const' here and removed the unused direct import of RescueAssistantScreen
      home: const MainNavigationWrapper(), 
    );
  }
}
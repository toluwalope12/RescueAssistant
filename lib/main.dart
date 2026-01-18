import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Services
import 'services/rescue_service.dart';
import 'services/voice_pipeline_service.dart';

// Screens
import 'screens/main_navigation_wrapper.dart';

// Models
import 'models/history_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Load Environment Variables (.env file)
  await dotenv.load(fileName: ".env");

  // 2. Initialize Hive for Flutter
  await Hive.initFlutter();

  // 3. Register the Type Adapter for History
  // Run: dart run build_runner build --delete-conflicting-outputs
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(HistoryEntryAdapter());
  }

  // 4. Open Boxes (One for history logs, one for SOS settings)
  await Hive.openBox<HistoryEntry>('history');
  await Hive.openBox('settings');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RescueService()),
        ChangeNotifierProvider(create: (_) => VoicePipelineService()),
      ],
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
      title: 'Rescue AI Assistant',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        useMaterial3: true,
      ),
      // The Wrapper handles the Bottom Navigation between tabs
      home: const MainNavigationWrapper(), 
    );
  }
}
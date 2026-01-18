// lib/models/history_entry.dart
import 'package:hive/hive.dart';

part 'history_entry.g.dart';

@HiveType(typeId: 0)
class HistoryEntry {
  @HiveField(0)
  final DateTime timestamp;

  @HiveField(1)
  final String transcription;

  @HiveField(2)
  final String responseText;

  @HiveField(3)
  final List<int>? responseAudio;

  HistoryEntry({
    required this.timestamp,
    required this.transcription,
    required this.responseText,
    this.responseAudio,
  });
}

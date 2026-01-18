import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/history_entry.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(title: const Text("Emergency History"), backgroundColor: Colors.transparent),
      // ValueListenableBuilder makes the UI update automatically when a new history item is saved
      body: ValueListenableBuilder(
        valueListenable: Hive.box<HistoryEntry>('history').listenable(),
        builder: (context, Box<HistoryEntry> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text("No history recorded yet.", style: TextStyle(color: Colors.white70)),
            );
          }

          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              // Show newest history items first
              final entry = box.getAt(box.length - 1 - index); 
              return ListTile(
                title: Text(entry?.timestamp.toString().substring(0, 16) ?? "Unknown Date"),
                subtitle: Text(entry?.responseText ?? "", maxLines: 2, overflow: TextOverflow.ellipsis),
                leading: const Icon(Icons.emergency, color: Colors.redAccent),
              );
            },
          );
        },
      ),
    );
  }
}
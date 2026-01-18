import 'package:flutter/material.dart';
import 'rescue_assistant_screen.dart';
import 'history_screen.dart'; 
import 'sos_contacts_screen.dart';

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key}); // Const constructor for performance

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 1; // Default to Rescue AI Home

  // These are now marked as const to satisfy the performance linter
  final List<Widget> _screens = const [
    HistoryScreen(),        
    RescueAssistantScreen(), 
    SOSContactsScreen(),     
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps the state of your screens alive
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A1A1A),
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.white38,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // Added 'const' to items to fix the performance warnings
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history), 
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic_none), 
            label: 'Rescue AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency_share), 
            label: 'SOS',
          ),
        ],
      ),
    );
  }
}
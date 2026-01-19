import 'package:flutter/material.dart';

class SOSContactsScreen extends StatelessWidget {
  // Added 'const' to the constructor
  const SOSContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold( // Added 'const' here
      backgroundColor: Color(0xFF0F0F0F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icons and Widgets inside a const Column should also be const
            Icon(Icons.contact_phone, size: 80, color: Colors.redAccent),
            SizedBox(height: 20),
            Text(
              "Emergency Contacts",
              style: TextStyle(
                color: Colors.white, 
                fontSize: 22, 
                fontWeight: FontWeight.bold
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "In the final version, you'll be able to select specific contacts from your Samsung phone here.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
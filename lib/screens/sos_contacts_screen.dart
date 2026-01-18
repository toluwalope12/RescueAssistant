import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class SOSContactsScreen extends StatefulWidget {
  const SOSContactsScreen({super.key});

  @override
  State<SOSContactsScreen> createState() => _SOSContactsScreenState();
}

class _SOSContactsScreenState extends State<SOSContactsScreen> {
  String? _savedContactName;
  String? _savedContactPhone;
  
  // Access the settings box opened in main.dart
  late Box _settingsBox;

  @override
  void initState() {
    super.initState();
    _settingsBox = Hive.box('settings');
    _loadSavedContact();
  }

  void _loadSavedContact() {
    setState(() {
      _savedContactName = _settingsBox.get('sos_name');
      _savedContactPhone = _settingsBox.get('sos_phone');
    });
  }

  Future<void> _pickContact() async {
    // Request permission to access contacts
    if (await FlutterContacts.requestPermission()) {
      // FIXED: Corrected method name to openExternalPick()
      final contact = await FlutterContacts.openExternalPick();
      
      if (contact != null && contact.phones.isNotEmpty) {
        final name = contact.displayName;
        // Clean the phone number to remove spaces/dashes for the SMS URI
        final phone = contact.phones.first.number.replaceAll(RegExp(r'\s+\b|\b\s+'), '');

        // Save to Hive locally on your Samsung
        await _settingsBox.put('sos_name', name);
        await _settingsBox.put('sos_phone', phone);

        setState(() {
          _savedContactName = name;
          _savedContactPhone = phone;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Emergency contact set to $name")),
          );
        }
      }
    } else {
      // If user denies permission, send them to Samsung system settings
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.contact_phone, size: 80, color: Colors.redAccent),
              const SizedBox(height: 20),
              const Text(
                "Emergency Contact",
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 24, 
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              
              // Display Area for Saved Contact
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      _savedContactName ?? "No contact selected",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    if (_savedContactPhone != null) ...[
                      const SizedBox(height: 5),
                      Text(
                        _savedContactPhone!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              ElevatedButton.icon(
                onPressed: _pickContact,
                icon: const Icon(Icons.person_add),
                label: const Text("SELECT FROM PHONE"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              const Text(
                "When you trigger the SOS button, the app will automatically use this contact and include AI-generated first aid steps.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white24, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
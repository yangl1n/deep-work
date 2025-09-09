import 'package:flutter/material.dart';
import '../../services/interuption.dart'; // adjust path if needed

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          "About Screen",
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.settings),
        onPressed: () {
          Interuption.openSettings();
        },
      ),
    );
  }
}

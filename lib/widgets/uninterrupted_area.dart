import 'package:flutter/material.dart';
class UninterruptedArea extends StatelessWidget {
  const UninterruptedArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200, // muted background
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.do_not_disturb_on, 
              size: 64, color: Colors.grey.shade600),
          const SizedBox(height: 16),
          const Text(
            "Uninterrupted period is active",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Notifications and messages are hidden until this ends.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

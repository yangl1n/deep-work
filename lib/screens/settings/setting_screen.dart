import 'package:flutter/material.dart';
import '../../services/interuption.dart'; // adjust path if needed
import 'ringtone_picker_screen.dart'; // import your picker screen

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // const Padding(
          //   padding: EdgeInsets.all(16.0),
          //   child: Text(
          //     "General",
          //     style: TextStyle(
          //       fontSize: 16,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.grey,
          //     ),
          //   ),
          // ),

          /// 🔹 Ringtone setting
          ListTile(
            leading: const Icon(Icons.music_note, color: Colors.blue),
            title: const Text("Ringtone"),
            subtitle: const Text("Choose alarm sound"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const RingtonePickerScreen(),
                ),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.security, color: Colors.black),
            title: const Text("Permission"),
            subtitle: const Text("Manage App Permission"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Interuption.openSettings();
            },
          ),

          const Divider(),


        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  static const MethodChannel _channel = MethodChannel('com.example.deepwork/rings');

  @override
  void initState() {
    super.initState();
    _startAlarm();
  }

  Future<void> _startAlarm() async {
    try {
      String? uri;

      // 1. Get saved ringtone (JSON)
      final savedJsonStr = await _channel.invokeMethod<String>('getSavedRingtone');

      if (savedJsonStr != null) {
        final Map<String, dynamic> savedMap = jsonDecode(savedJsonStr);
        uri = savedMap['uri']?.toString();
      }

      // 2. If no saved ringtone, fallback to first system ringtone
      if (uri == null || uri.isEmpty) {
        final ringtonesStr =
            await _channel.invokeMethod<String>('getSystemRingtones');
        if (ringtonesStr != null) {
          final List<dynamic> list = jsonDecode(ringtonesStr);
          if (list.isNotEmpty) {
            uri = list.first['uri']?.toString();
          }
        }
      }

      // 3. Play if valid
      if (uri != null && uri.isNotEmpty) {
        await _channel.invokeMethod('playMusic', {'uri': uri});
      } else {
        debugPrint('No ringtone available to play');
      }
    } catch (e) {
      debugPrint('Error starting alarm: $e');
    }
  }


  Future<void> _stopAlarm() async {
    try {
      await _channel.invokeMethod('stopMusic');
    } catch (e) {
      debugPrint('Error stopping alarm: $e');
    } finally {
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _stopAlarm(); // safety stop
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Illustration / icon
                Icon(Icons.self_improvement,
                    size: 120, color: Colors.blue.shade400),
                const SizedBox(height: 30),

                // Message
                Text(
                  "Time for a break 🌿",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700),
                ),
                const SizedBox(height: 10),
                Text(
                  "Stretch, breathe, and relax for a moment.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18, color: Colors.blueGrey.shade600),
                ),

                const SizedBox(height: 40),

                // Stop button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade400,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  icon: const Icon(Icons.stop),
                  label: const Text(
                    "Stop & Return",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  onPressed: _stopAlarm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

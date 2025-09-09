import 'dart:convert';
import 'package:flutter/services.dart';

class Ring {
  static const MethodChannel _channel = MethodChannel('com.example.deepwork/rings');

  /// Get system ringtones from Android
  static Future<List<Map<String, String>>> getSystemRingtones() async {
    final String result = await _channel.invokeMethod('getSystemRingtones');
    final List<dynamic> list = json.decode(result);
    return list.map((e) => Map<String, String>.from(e)).toList();
  }

  /// Play music by URI
  static Future<void> playMusic(String uri) async {
    await _channel.invokeMethod('playMusic', {'uri': uri});
  }

  /// Stop music
  static Future<void> stopMusic() async {
    await _channel.invokeMethod('stopMusic');
  }

  /// Save ringtone
  static Future<void> saveRingtone(String uri) async {
    await _channel.invokeMethod('saveRingtone', {'uri': uri});
  }

  /// Get saved ringtone
  static Future<String?> getSavedRingtone() async {
    final String? uri = await _channel.invokeMethod('getSavedRingtone');
    return uri;
  }
}

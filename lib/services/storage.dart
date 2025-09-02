import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String countdownKey = 'countdown_seconds';
  static const String wechatKey = "wechat_notifications";

  static Future<void> saveCountdown(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(countdownKey, seconds);
  }

  static Future<int> loadCountdown() async {
    final prefs = await SharedPreferences.getInstance();
    // Default 1 hour = 3600 seconds
    return prefs.getInt(countdownKey) ?? 3600;
  }

  static Future<void> saveNotifications({required Map<String, List<Map<String, dynamic>>> notifications, required String app}) async {
    final prefs = await SharedPreferences.getInstance();
    // Encode list of maps to JSON string
    final jsonString = jsonEncode(notifications);
    if (app == "wechat") {
      // print('Saved $jsonString');
      await prefs.setString(wechatKey, jsonString);
    }
  }

  static Future<void> deleteNotifications(String app, String person) async {
    final Map<String, List<Map<String, dynamic>>> notifications = await loadNotifications(app: app);

    notifications.remove(person);

    // Save back
    await saveNotifications(app: app, notifications: notifications);
  }

  static Future<Map<String, List<Map<String, dynamic>>>> loadNotifications({required String app}) async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString;
    if (app == "wechat") {
      jsonString = prefs.getString(wechatKey);
    }
    if (jsonString == null) {
      // print("no data stored yet.");
      return <String, List<Map<String, dynamic>>>{}; // no data stored yet
    }
    // print('Load $jsonString');
    final Map<String, dynamic> decoded = jsonDecode(jsonString);
    final result = decoded.map((key, value) {
            final List<Map<String, dynamic>> parsedList =
             (value as List).map((e) => Map<String, dynamic>.from(e)).toList();
            return MapEntry(key, parsedList);
          });
    return result;
  }

}

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../constants/type.dart';
import 'dart:async';

class OtherStorageService {
  ///  Other storage structure:
  ///       a dictonary of package, values are a list of messages sent by the same package
  ///       Each element in list is one message, which is a dictionary.
  ///  Eg. {"package": [ {""}
  ///                ],
  ///       "Mike": }
  ///  
  static const String otherKey = "other_notifications";
  static final _controller = StreamController<void>.broadcast();
  static Stream<void> get stream => _controller.stream; //anyone wants to know the change should listen to it.
  static Future<void> saveNotifications({required otherDict notifications}) async {
    final prefs = await SharedPreferences.getInstance();
    // Encode list of maps to JSON string
    final jsonString = jsonEncode(notifications);
    await prefs.setString(otherKey, jsonString);
    _controller.add(null);
  }

  static Future<void> deleteNotifications(String who) async {
    final otherDict notifications = await loadNotifications();
    notifications.remove(who);
    // Save back
    await saveNotifications(notifications: notifications);
  }

  static Future<otherDict> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(otherKey);
    if (jsonString == null) {
      // print("no data stored yet.");
      otherDict result = {};
      return result; // no data stored yet
    }
    // print('Load $jsonString');
    final Map<String, dynamic> decoded = jsonDecode(jsonString);
    final result = decoded.map((key, value) {
            final otherMsgList messages =
             (value as List).map((e) => otherMsg.from(e)).toList(); //Convert type
            return MapEntry(key, messages);
          });
    return result;
  }

}

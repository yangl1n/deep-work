import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../constants/type.dart';
import 'dart:async';

class WechatStorageService {
  ///  Wechat storage structure:
  ///       a dictonary of who, values are a list of messages sent by the same person
  ///       Each element in list is one message, which is a dictionary.
  ///  Eg. {"John": [ {""}
  ///                ],
  ///       "Mike": }
  ///  
  static const String wechatKey = "wechat_notifications";
  static final _controller = StreamController<void>.broadcast();
  static Stream<void> get stream => _controller.stream; //anyone wants to know the change should listen to it.
  static Future<void> saveNotifications({required wechatDict notifications}) async {
    final prefs = await SharedPreferences.getInstance();
    // Encode list of maps to JSON string
    final jsonString = jsonEncode(notifications);
    await prefs.setString(wechatKey, jsonString);
    _controller.add(null);
  }

  static Future<void> deleteNotifications(String who) async {
    final wechatDict notifications = await loadNotifications();
    notifications.remove(who);
    // Save back
    await saveNotifications(notifications: notifications);
  }

  static Future<wechatDict> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(wechatKey);
    if (jsonString == null) {
      // print("no data stored yet.");
      wechatDict result = {};
      return result; // no data stored yet
    }
    // print('Load $jsonString');
    final Map<String, dynamic> decoded = jsonDecode(jsonString);
    final result = decoded.map((key, value) {
            final wechatMsgList messages =
             (value as List).map((e) => wechatMsg.from(e)).toList(); //Convert type
            return MapEntry(key, messages);
          });
    return result;
  }

}

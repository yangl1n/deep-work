import 'package:flutter/services.dart';
import 'dart:async';
import 'wechat_storage.dart';
import 'other_storage.dart';
import '../constants/appname.dart';
import '../constants/type.dart';
class Interuption {
  static const _channel = MethodChannel("com.example.deepwork/notifications");
  /// Call this once at app startup
  static void init() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == "onNotificationReceived") {
        final Map<dynamic, dynamic> args = call.arguments;
        final message = Map<String, dynamic>.from(args);
        print('Interuption receices a new msg: $message');
        final data = _parseMessage(message);
        print("Interuption parse meesage ${data}");
        dynamic notifications;
        switch (data["app"]) {
          case AppName.WECHAT:
            notifications = await WechatStorageService.loadNotifications();
            _addNotifications(notifications, data);
            print('notification add data $notifications');
            await WechatStorageService.saveNotifications(notifications: notifications);
            break;
          default: // AppName.NOTFOUND
            notifications = await OtherStorageService.loadNotifications();
            _addNotifications(notifications, data);
            print('notification add data $notifications');
            await OtherStorageService.saveNotifications(notifications: notifications);
            break;
        }
      }
    });
  }

  /// Example method to check if permission is granted
  static Future<bool> checkPermission() async {
    final result = await _channel.invokeMethod("checkPermissions");
    return result == true;
  }

  // Open notification access settings (Android side can implement this if you add handler)
  static Future<void> openSettings() async {
    try {
      await _channel.invokeMethod("openSettings");
    } on PlatformException catch (e) {
      print("Error opening settings: $e");
    }
  }

  static void _addNotifications(notifications, data) {
      switch (data["app"]) {
          case AppName.WECHAT:
              notifications.putIfAbsent(data["title"], ()=><wechatMsg>[]).add(data);
              break;
          default: //case AppName.NOTFOUND
              notifications.putIfAbsent(data["package"], ()=><otherMsg>[]).add(data);
              break;
      }
  }
  static Map<String, dynamic> _parseMessage(Map<String, dynamic> data) {
    // Parse per app
    // add attribute app, if not enabled, assigned 'others'
    final package = data["package"];
    data["app"] = AppName.enablePackages[package] ?? AppName.NOTFOUND;
    switch (data["app"]) {
        case AppName.WECHAT:
          return {
                  "app": data["app"],
                  "title": data["title"] ?? 'unknown',
                  "text": data["text"] ?? 'unknown',
                  "category": data["category"] ?? 'unknown',
                  "when": data["when"] ?? 'unknown',
                  "meta": data
                };
          
        default: //Not found case
          return {
                  "app": data["app"],
                  "package": data["package"] ?? 'unknown',
                  "title": data["title"] ?? 'unknown',
                  "when": data["when"] ?? 'unknown',
                  "text": data["text"] ?? 'unknown',
                  "meta": data
                };
    }
  }
}

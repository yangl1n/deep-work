import 'dart:async';
import 'package:flutter/material.dart';
import '../services/wechat_storage.dart';
import '../services/other_storage.dart';
import '../utils.dart';
import '../constants/type.dart';

class InteruptsModel extends ChangeNotifier {
  /// Responsible for loading data by app and parse it ready for display
  ///
  wechatMsgList _wechat_notifications = [];

  wechatMsgList get wechat_notifications => _wechat_notifications;

  otherMsgList _other_notifications = [];

  otherMsgList get other_notifications => _other_notifications;

  InteruptsModel() {
    _loadFromStorage();
    WechatStorageService.stream.listen((_) { _loadFromStorage();}); //Listen changes in storage
    OtherStorageService.stream.listen((_) { _loadFromStorage();}); //Listen changes in storage
  }

  Future<void> _loadFromStorage() async {
    print('Notified by Interuption.');
    wechatDict allMsg = await WechatStorageService.loadNotifications();
    _wechat_notifications = _organizeWechatMessages(allMsg);
    otherDict allOtherMsg = await OtherStorageService.loadNotifications();
    _other_notifications = _organizeOtherMessages(allOtherMsg);
    notifyListeners();
  }

  void restore() {
    _loadFromStorage();
    notifyListeners();
  }

  static wechatMsgList _organizeWechatMessages(wechatDict messages) {
      print("organize wechat messages");
      return messages.entries.map((entry) {
        final messagesPer = entry.value;
        // Sort by time (latest last)
        messagesPer.sort((a, b) => (a['when'] as int).compareTo(b['when'] as int));
        return {
          "who": messagesPer.first["title"],
          "count": messagesPer.length,
          "latest_text": messagesPer.last["text"],
          "latest_when": formatTime(messagesPer.last["when"]),
          "details": wechatMsgList.from(messagesPer),
        };
      }).toList();
  }

  static otherMsgList _organizeOtherMessages(otherDict messages) {
      print("organize other messages");
      return messages.entries.map((entry) {
        final messagesPer = entry.value;
        // Sort by time (latest last)
        messagesPer.sort((a, b) => (a['when'] as int).compareTo(b['when'] as int));
        return {
          "package": messagesPer.first["package"],
          "count": messagesPer.length,
          "title": messagesPer.last["title"],
          "latest_when": formatTime(messagesPer.last["when"]),
          "details": otherMsgList.from(messagesPer),
        };
      }).toList();
  }
}

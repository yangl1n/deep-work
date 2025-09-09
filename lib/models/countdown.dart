import 'dart:async';
import 'package:flutter/material.dart';
import '../services/storage.dart';
import '../screens/home/alarm_screen.dart';

class CountdownModel extends ChangeNotifier {
  int _timeLeft = 3600;
  int _totalTime = 3600;
  bool _isRunning = false;
  Timer? _timer;
  VoidCallback? onAlarmTriggered;

  int get timeLeft => _timeLeft;
  int get totalTime => _totalTime;
  bool get isRunning => _isRunning;

  CountdownModel() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    int savedTime = await StorageService.loadCountdown();
    _totalTime = savedTime;
    _timeLeft = savedTime;
    notifyListeners();
  }

  void start() {
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else {
        stop();
        // Trigger callback when finished
        if (onAlarmTriggered != null) {
          onAlarmTriggered!();
        }
      }
    });
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _isRunning = false;
    _timer = null;
    _timeLeft = _totalTime;
    notifyListeners();
  }

  void setTime(int seconds) {
    _totalTime = seconds;
    _timeLeft = seconds;
    StorageService.saveCountdown(seconds); // async fire-and-forget
    notifyListeners();
  }
}

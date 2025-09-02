package com.example.deepwork

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.deepwork.notifications.NotificationManager

class MainActivity : FlutterActivity() {
    private val notificationChannel = "com.example.deepwork/notifications"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        var notiChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, notificationChannel)
        var notiManager = NotificationManager(this, notiChannel)
    }

}

package com.example.deepwork

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.example.deepwork.notifications.NotificationPlugin
import com.example.deepwork.rings.RingPlugin

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Register the plugin
        flutterEngine.plugins.add(NotificationPlugin())
        flutterEngine.plugins.add(RingPlugin())
    }
}

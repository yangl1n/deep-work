package com.example.deepwork.notifications

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.Intent
import android.provider.Settings

class NotificationPlugin : FlutterPlugin {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    private val notificationChannelName = "com.example.deepwork/notifications"

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, notificationChannelName)

        // Set channel for NotificationListenerService
        NotificationListener.setChannel(channel)

        // Optional: expose methods to Flutter
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "checkPermissions" -> result.success(checkPermissions())
                "openSettings" -> {
                    openNotificationSettings()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        NotificationListener.setChannel(null)
    }

    private fun checkPermissions(): Boolean {
        val sets = Settings.Secure.getString(context.contentResolver, "enabled_notification_listeners")
        return sets?.contains(context.packageName) == true
    }

    private fun openNotificationSettings() {
        val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }
}
    
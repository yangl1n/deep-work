package com.example.deepwork.notifications
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.engine.FlutterEngine
import android.content.Context
class NotificationManager(private val context: Context, private val channel: MethodChannel)  {
    init {
        NotificationListener.setChannel(channel)
        channel.setMethodCallHandler{ call, result ->
                when (call.method) {
                    "checkPermissions" -> {
                        val hasPermission  = checkPermissions()
                        result.success(hasPermission)
                    }
                    "openSettings" -> {
                        openNotificationSettings()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
    
    fun checkPermissions(): Boolean {
        val sets = Settings.Secure.getString(context.contentResolver, "enabled_notification_listeners")
        return sets?.contains(context.packageName) == true
    }

    fun openNotificationSettings() {
            val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
    }
    
}
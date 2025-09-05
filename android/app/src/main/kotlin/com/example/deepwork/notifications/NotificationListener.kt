package com.example.deepwork.notifications
import android.service.notification.NotificationListenerService
import io.flutter.plugin.common.MethodChannel
import android.service.notification.StatusBarNotification
import android.os.Bundle
import android.app.Notification

class NotificationListener: NotificationListenerService()  {

    companion object {
        private var channel: MethodChannel? = null
        fun setChannel(methodChannel: MethodChannel?) {
            channel = methodChannel
        }
    }

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val notification = sbn.notification
        val extras: Bundle = notification.extras
        // if (sbn.packageName !in enabledPackages.keys) {
        //     return
        // }
        print(notification.actions)
        val data = mutableMapOf<String, Any?>(
            "package" to sbn.packageName,
            "when" to notification.`when`,
            "category" to notification.category,
            "tickerText" to notification.tickerText?.toString(),
            "priority" to notification.priority,
            "visibility" to notification.visibility,
        )

        // From Extras (text fields, media, etc.)
        val extrasMap = mapOf(
            "title" to extras.getCharSequence(Notification.EXTRA_TITLE)?.toString(),
            "text" to extras.getCharSequence(Notification.EXTRA_TEXT)?.toString()
        )

        data.putAll(extrasMap)

        channel?.invokeMethod("onNotificationReceived", data)
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification) {
        // Optionally notify Flutter
    }

    
}
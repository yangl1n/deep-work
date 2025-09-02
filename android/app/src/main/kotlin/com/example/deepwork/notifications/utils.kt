package com.example.deepwork.notifications

import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale
import kotlin.math.abs

fun formatNotificationTime(epochMillis: Long): String {
    val now = Calendar.getInstance()
    val notifTime = Calendar.getInstance().apply { timeInMillis = epochMillis }

    // Format for "today"
    val timeFormat = SimpleDateFormat("HH:mm", Locale.getDefault())

    // Check if same year, month, day
    val sameDay = now.get(Calendar.YEAR) == notifTime.get(Calendar.YEAR) &&
                now.get(Calendar.DAY_OF_YEAR) == notifTime.get(Calendar.DAY_OF_YEAR)

    if (sameDay) {
        return timeFormat.format(Date(epochMillis))
    }

    // Check yesterday
    now.add(Calendar.DAY_OF_YEAR, -1)
    val isYesterday = now.get(Calendar.YEAR) == notifTime.get(Calendar.YEAR) &&
                    now.get(Calendar.DAY_OF_YEAR) == notifTime.get(Calendar.DAY_OF_YEAR)

    if (isYesterday) {
        return "Yesterday"
    }

    // Otherwise, days ago
    val diffMillis = Calendar.getInstance().timeInMillis - epochMillis
    val daysAgo = (diffMillis / (1000 * 60 * 60 * 24)).toInt()
    return "$daysAgo days ago"
}
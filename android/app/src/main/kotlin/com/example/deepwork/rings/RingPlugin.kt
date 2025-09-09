package com.example.deepwork.rings

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.Intent
import android.provider.Settings
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.engine.FlutterEngine
import org.json.JSONArray
import org.json.JSONObject
import android.util.Log
import java.io.File
class RingPlugin : FlutterPlugin {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    private val ChannelName = "com.example.deepwork/rings"
    private var mediaPlayer: MediaPlayer? = null
    private val PREFS_NAME = "alarm_prefs"
    private val KEY_RINGTONE_URI = "selected_ringtone"

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, ChannelName)

        // Optional: expose methods to Flutter
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getSystemRingtones" -> {
                    val ringtones = getSystemRingtones()
                    result.success(ringtones)
                }
                "playMusic" -> {
                    val uriString = call.argument<String>("uri")
                    if (uriString != null) {
                        playMusic(uriString)
                        result.success(true)
                    } else {
                        result.error("INVALID_URI", "No URI provided", null)
                    }
                }
                "stopMusic" -> {
                    stopMusic()
                    result.success(true)
                }

                "saveRingtone" -> {
                    val uriString = call.argument<String>("uri")
                    val title = call.argument<String>("title")
                    if (uriString != null && title != null) {
                        saveRingtone(uriString, title)
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGS", "URI or title missing", null)
                    }
                }

                "getSavedRingtone" -> {
                    val saved = getSavedRingtone()
                    result.success(saved)
                }

                else -> result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        stopMusic()
    }

    private fun getSystemRingtones(): String {
        val manager = RingtoneManager(context)
        manager.setType(RingtoneManager.TYPE_ALARM or RingtoneManager.TYPE_RINGTONE or RingtoneManager.TYPE_NOTIFICATION)
        val cursor = manager.cursor

        val list = JSONArray()
        while (cursor.moveToNext()) {
            val title = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
            val uri = manager.getRingtoneUri(cursor.position).toString()

            val json = JSONObject()
            json.put("title", title)
            json.put("uri", uri)
            list.put(json)
        }
        cursor.close()

        return list.toString() // JSON array string
    }

    private fun playMusic(uriString: String) {
        stopMusic() // stop previous playback

        try {
            val uri: Uri = if (uriString.startsWith("content://") || uriString.startsWith("android.resource://")) {
                Uri.parse(uriString)
            } else {
                // Local file path, e.g. /storage/emulated/0/Music/song.mp3
                Uri.fromFile(File(uriString))
            }

            mediaPlayer = MediaPlayer().apply {
                setDataSource(context, uri)
                isLooping = true
                setOnPreparedListener { it.start() }
                setOnErrorListener { mp, what, extra ->
                    Log.e("RingPlugin", "MediaPlayer error: what=$what, extra=$extra")
                    true
                }
                prepareAsync()
            }
        } catch (e: Exception) {
            Log.e("RingPlugin", "Error playing music: $e")
        }
    }

    private fun stopMusic() {
        mediaPlayer?.let {
            if (it.isPlaying) it.stop()
            it.release()
        }
        mediaPlayer = null
    }

    private fun saveRingtone(uriString: String, title: String) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

        // Create JSON string like system ringtone
        val json = JSONObject()
        json.put("title", title)
        json.put("uri", uriString)

        prefs.edit().putString(KEY_RINGTONE_URI, json.toString()).apply()
    }

    /** 🔹 Retrieve saved ringtone JSON string */
    private fun getSavedRingtone(): String? {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        return prefs.getString(KEY_RINGTONE_URI, null)
    }
}
    
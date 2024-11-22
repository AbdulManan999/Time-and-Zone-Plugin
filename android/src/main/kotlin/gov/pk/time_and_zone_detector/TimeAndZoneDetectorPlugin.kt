package gov.pk.time_and_zone_detector

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.content.Context
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings

/** TimeAndZoneDetectorPlugin */
class TimeAndZoneDetectorPlugin: FlutterPlugin, MethodCallHandler/*, EventChannel.StreamHandler*/ {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var timeEventChannel : EventChannel
  private lateinit var zoneEventChannel : EventChannel
  private val channelName = "gov.pk.timezone/settings"
  private val eventTimeChannelName = "gov.pk.timezone/time/changes"
  private val eventZoneChannelName = "gov.pk.timezone/zone/changes"
  private var timeEventSink: EventChannel.EventSink? = null
  private var zoneEventSink: EventChannel.EventSink? = null
  private var handler: Handler? = null
  private var previousTimeAutomatic: Boolean = false
  private var previousZoneAutomatic: Boolean = false
  private lateinit var binding: FlutterPlugin.FlutterPluginBinding

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    binding = flutterPluginBinding
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelName)
    channel.setMethodCallHandler(this)

    // Event channel for sending updates to Flutter
    timeEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, eventTimeChannelName)
    timeEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        timeEventSink = events
        startListeningForTimeChanges(binding.applicationContext)
      }

      override fun onCancel(arguments: Any?) {
        timeEventSink = null
      }
    })
    zoneEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, eventZoneChannelName)
    zoneEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        zoneEventSink = events
        startListeningForZoneChanges(binding.applicationContext)
      }

      override fun onCancel(arguments: Any?) {
        zoneEventSink = null
      }
    })
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "isTimeAutomatic" -> result.success(isTimeAutomatic(binding.applicationContext))
      "isZoneAutomatic" -> result.success(isZoneAutomatic(binding.applicationContext))
      else -> result.notImplemented()
    }
    /*if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }*/
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    timeEventChannel.setStreamHandler(null)
    zoneEventChannel.setStreamHandler(null)
    // Clean up resources
    handler?.removeCallbacksAndMessages(null)
  }

//  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
//    eventSink = events
//    startListeningForTimeChanges(binding.applicationContext)
//    startListeningForZoneChanges(binding.applicationContext)
//  }

  /*override fun onCancel(arguments: Any?) {
    eventSink = null
  }*/

  // Separate function for listening to automatic time changes
  private fun startListeningForTimeChanges(context: Context) {
    handler = Handler(Looper.getMainLooper())
    val runnable = object : Runnable {
      override fun run() {
        val currentTimeAutomatic = isTimeAutomatic(context)

        if (currentTimeAutomatic != previousTimeAutomatic) {
//          eventSink?.success(currentTimeAutomatic)
          timeEventSink?.success(mapOf("time" to currentTimeAutomatic))
          previousTimeAutomatic = currentTimeAutomatic
        }

        handler?.postDelayed(this, 2000) // Check every 10 seconds
      }
    }

    handler?.post(runnable)
  }

  // Start listening for automatic timezone changes and send true/false when a change occurs
  private fun startListeningForZoneChanges(context: Context) {
    handler = Handler(Looper.getMainLooper())
    val runnable = object : Runnable {
      override fun run() {
        val currentZoneAutomatic = isZoneAutomatic(context)

        if (currentZoneAutomatic != previousZoneAutomatic) {
//          eventSink?.success(currentZoneAutomatic)
          zoneEventSink?.success(mapOf("zone" to currentZoneAutomatic))
          previousZoneAutomatic = currentZoneAutomatic
        }

        handler?.postDelayed(this, 2000) // Check every 10 seconds
      }
    }

    handler?.post(runnable)
  }

  // Check if automatic time is enabled
  private fun isTimeAutomatic(context: Context): Boolean {
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
      Settings.Global.getInt(context.contentResolver, Settings.Global.AUTO_TIME, 0) == 1
    } else {
      Settings.System.getInt(context.contentResolver, Settings.System.AUTO_TIME, 0) == 1
    }
  }

  // Check if automatic timezone is enabled
  private fun isZoneAutomatic(context: Context): Boolean {
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
      Settings.Global.getInt(context.contentResolver, Settings.Global.AUTO_TIME_ZONE, 0) == 1
    } else {
      Settings.System.getInt(context.contentResolver, Settings.System.AUTO_TIME_ZONE, 0) == 1
    }
  }

  /*// Required for plugin registration in older Flutter versions (1.11 and below)
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      eventChannel.setStreamHandler(TimeAndZoneDetectorPlugin()) // Set StreamHandler here as well
    }
  }*/
}

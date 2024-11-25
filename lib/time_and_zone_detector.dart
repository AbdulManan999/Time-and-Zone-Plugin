import 'package:flutter/services.dart';

import 'time_zone.dart';
import 'time_and_zone_detector_platform_interface.dart';

class TimeAndZoneDetector {
  static const MethodChannel _channel = MethodChannel('gov.pk.timezone/settings');
  static const EventChannel _timeEventChannel = EventChannel('gov.pk.timezone/time/changes');
  static const EventChannel _zoneEventChannel = EventChannel('gov.pk.timezone/zone/changes');

  Future<String?> getPlatformVersion() {
    return TimeAndZoneDetectorPlatform.instance.getPlatformVersion();
  }

  // Start listening for automatic time and timezone changes
  static Stream<TimeZone> startListeningForTimeChanges() {
    return _timeEventChannel.receiveBroadcastStream().map((event) {
      final Map<String, dynamic> eventMap = Map<String, dynamic>.from(event);
      return TimeZone.fromJson(eventMap);
      // return event;
    });
  }

  // Start listening for automatic time and timezone changes
  static Stream<TimeZone> startListeningForZoneChanges() {
    return _zoneEventChannel.receiveBroadcastStream().map((event) {
      final Map<String, dynamic> eventMap = Map<String, dynamic>.from(event);
      return TimeZone.fromJson(eventMap);
      // return event;
    });
  }

  // Method to check if automatic time is enabled
  static Future<bool> isTimeAutomatic() async {
    try {
      final bool result = await _channel.invokeMethod('isTimeAutomatic');
      return result;
    } on PlatformException catch (e) {
      return false;
    }
  }

  // Method to check if automatic timezone is enabled
  static Future<bool> isZoneAutomatic() async {
    try {
      final bool result = await _channel.invokeMethod('isZoneAutomatic');
      return result;
    } on PlatformException catch (e) {
      return false;
    }
  }
}

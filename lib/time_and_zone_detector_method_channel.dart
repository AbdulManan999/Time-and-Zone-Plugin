import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'time_and_zone_detector_platform_interface.dart';

/// An implementation of [TimeAndZoneDetectorPlatform] that uses method channels.
class MethodChannelTimeAndZoneDetector extends TimeAndZoneDetectorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('time_and_zone_detector');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'time_and_zone_detector_method_channel.dart';

abstract class TimeAndZoneDetectorPlatform extends PlatformInterface {
  /// Constructs a TimeAndZoneDetectorPlatform.
  TimeAndZoneDetectorPlatform() : super(token: _token);

  static final Object _token = Object();

  static TimeAndZoneDetectorPlatform _instance = MethodChannelTimeAndZoneDetector();

  /// The default instance of [TimeAndZoneDetectorPlatform] to use.
  ///
  /// Defaults to [MethodChannelTimeAndZoneDetector].
  static TimeAndZoneDetectorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TimeAndZoneDetectorPlatform] when
  /// they register themselves.
  static set instance(TimeAndZoneDetectorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

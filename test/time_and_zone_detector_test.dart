import 'package:flutter_test/flutter_test.dart';
import 'package:time_and_zone_detector/time_and_zone_detector.dart';
import 'package:time_and_zone_detector/time_and_zone_detector_platform_interface.dart';
import 'package:time_and_zone_detector/time_and_zone_detector_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTimeAndZoneDetectorPlatform
    with MockPlatformInterfaceMixin
    implements TimeAndZoneDetectorPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TimeAndZoneDetectorPlatform initialPlatform = TimeAndZoneDetectorPlatform.instance;

  test('$MethodChannelTimeAndZoneDetector is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTimeAndZoneDetector>());
  });

  test('getPlatformVersion', () async {
    TimeAndZoneDetector timeAndZoneDetectorPlugin = TimeAndZoneDetector();
    MockTimeAndZoneDetectorPlatform fakePlatform = MockTimeAndZoneDetectorPlatform();
    TimeAndZoneDetectorPlatform.instance = fakePlatform;

    expect(await timeAndZoneDetectorPlugin.getPlatformVersion(), '42');
  });
}

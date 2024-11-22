import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_and_zone_detector/time_and_zone_detector_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelTimeAndZoneDetector platform = MethodChannelTimeAndZoneDetector();
  const MethodChannel channel = MethodChannel('time_and_zone_detector');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}

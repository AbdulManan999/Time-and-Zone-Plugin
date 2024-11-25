import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:time_and_zone_detector/TimeZone.dart';
import 'package:time_and_zone_detector/time_and_zone_detector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /*String _platformVersion = 'Unknown';
  final _timeAndZoneDetectorPlugin = TimeAndZoneDetector();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _timeAndZoneDetectorPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }*/

  String _timeSetting = 'Unknown';
  String _zoneSetting = 'Unknown';

  @override
  void initState() {
    super.initState();

    // Start listening for changes
    // TimeAndZoneDetector.startListeningForTimeChanges().listen((TimeZone timeZone) {
    //   setState(() {
    //     // if (setting is bool) {
    //     //   // Handle time and zone separately depending on the setting
    //     //   _timeSetting = setting ? 'Automatic Time: Enabled' : 'Automatic Time: Disabled';
    //     //   _zoneSetting = setting ? 'Automatic Timezone: Enabled' : 'Automatic Timezone: Disabled';
    //     // }
    //     if (timeZone.time != null) {
    //       _timeSetting = timeZone.time! ? 'Automatic Time: Enabled' : 'Automatic Time: Disabled';
    //     } else {
    //       _timeSetting = "Automatic Time: Disabled";
    //     }
    //   });
    // });
    //
    // // Start listening for changes
    // TimeAndZoneDetector.startListeningForZoneChanges().listen((TimeZone timeZone) {
    //   setState(() {
    //     // if (setting is bool) {
    //     //   // Handle time and zone separately depending on the setting
    //     //   _timeSetting = setting ? 'Automatic Time: Enabled' : 'Automatic Time: Disabled';
    //     //   _zoneSetting = setting ? 'Automatic Timezone: Enabled' : 'Automatic Timezone: Disabled';
    //     // }
    //     if (timeZone.zone != null) {
    //       _zoneSetting =
    //           timeZone.zone! ? 'Automatic Timezone: Enabled' : 'Automatic Timezone: Disabled';
    //     } else {
    //       _zoneSetting = "Automatic Timezone: Disabled";
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Timezone & Time Settings'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  bool result = await TimeAndZoneDetector.isTimeAutomatic();
                  _timeSetting = result ? 'Automatic Time: Enabled' : 'Automatic Time: Disabled';
                  setState(() {});
                },
                child: Text(_timeSetting),
              ),
              SizedBox(height: 20),
              InkWell(
                  onTap: () async {
                    bool result = await TimeAndZoneDetector.isZoneAutomatic();
                    _zoneSetting =
                        result ? 'Automatic Timezone: Enabled' : 'Automatic Timezone: Disabled';
                    setState(() {});
                  },
                  child: Text(_zoneSetting)),
            ],
          ),
        ),
      ),
    );
  }
}

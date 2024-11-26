import 'dart:io';

import 'package:flutter/material.dart';

import 'package:time_and_zone_detector/time_zone.dart';
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
  String _timeSetting = 'Unknown';
  String _zoneSetting = 'Unknown';

  @override
  void initState() {
    super.initState();

    // Start listening for time changes (Android Only)
    if (Platform.isAndroid) {
      TimeAndZoneDetector.startListeningForTimeChanges().listen((TimeZone timeZone) {
        setState(() {
          if (timeZone.time != null) {
            _timeSetting = timeZone.time! ? 'Automatic Time: Enabled' : 'Automatic Time: Disabled';
          } else {
            _timeSetting = "Automatic Time: Disabled";
          }
        });
      });
    }

    // Start listening for zone changes
    TimeAndZoneDetector.startListeningForZoneChanges().listen((TimeZone timeZone) {
      setState(() {
        if (timeZone.zone != null) {
          _zoneSetting =
              timeZone.zone! ? 'Automatic Timezone: Enabled' : 'Automatic Timezone: Disabled';
        } else {
          _zoneSetting = "Automatic Timezone: Disabled";
        }
      });
    });
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
              Visibility(
                visible: Platform.isAndroid,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        bool result = await TimeAndZoneDetector.isTimeAutomatic();
                        _timeSetting =
                            result ? 'Automatic Time: Enabled' : 'Automatic Time: Disabled';
                        setState(() {});
                      },
                      child: Text(_timeSetting),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
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

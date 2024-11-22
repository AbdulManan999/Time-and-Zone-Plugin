import Flutter
import UIKit

public class TimeAndZoneDetectorPlugin: NSObject, FlutterPlugin {
    private var timeEventSink: FlutterEventSink?
    private var zoneEventSink: FlutterEventSink?
    private var previousTimeAutomatic = false
    private var previousZoneAutomatic = false
    private var timer: Timer?

    public static func register(with registrar: FlutterPluginRegistrar) {
      let channel = FlutterMethodChannel(name: "gov.pk.timezone/settings", binaryMessenger: registrar.messenger())
      let timeEventChannel = FlutterEventChannel(name: "gov.pk.timezone/time/changes", binaryMessenger: registrar.messenger())
      let zoneEventChannel = FlutterEventChannel(name: "gov.pk.timezone/zone/changes", binaryMessenger: registrar.messenger())

      let instance = TimeAndZoneDetectorPlugin()
      registrar.addMethodCallDelegate(instance, channel: channel)

      timeEventChannel.setStreamHandler(instance)
      zoneEventChannel.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "isTimeAutomatic":
              result(isTimeAutomatic())
            case "isZoneAutomatic":
              result(isZoneAutomatic())
            case "getPlatformVersion":
              result("iOS " + UIDevice.current.systemVersion)
            default:
              result(FlutterMethodNotImplemented)
        }
    }

    private func isTimeAutomatic() -> Bool {
        if #available(iOS 10.0, *) {
            return UserDefaults.standard.bool(forKey: "AppleGlobalAutomaticTimeSetting")
        } else {
            return false // Automatic time setting might not be directly accessible in earlier iOS versions
        }
    }

    private func isZoneAutomatic() -> Bool {
        // iOS does not provide a direct API to check if automatic timezone is enabled.
        // For demonstration purposes, we'll use a heuristic: check if daylight saving time is enabled
        return TimeZone.current.isDaylightSavingTime()
    }

    private func startListeningForTimeChanges() {
        /* DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            let currentZoneAutomatic = self.isZoneAutomatic()

            if currentZoneAutomatic != self.previousZoneAutomatic {
                self.timeEventSink?(["time": currentTimeAutomatic])
                self.previousZoneAutomatic = currentZoneAutomatic
            }

            self.startListeningForTimeChanges()
        } */
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            let currentTimeAutomatic = self.isTimeAutomatic()
            if currentTimeAutomatic != self.previousTimeAutomatic {
                self.timeEventSink?(["time": currentTimeAutomatic])
                self.previousTimeAutomatic = currentTimeAutomatic
            }
        }
    }

    private func startListeningForZoneChanges() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            let currentZoneAutomatic = self.isZoneAutomatic()
            if currentZoneAutomatic != self.previousZoneAutomatic {
                self.zoneEventSink?(["zone": currentZoneAutomatic])
                self.previousZoneAutomatic = currentZoneAutomatic
            }
        }
    }
}

extension TimeAndZoneDetectorPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) {
        if let eventArguments = arguments as? String {
            if eventArguments == "time" {
                timeEventSink = events
                startListeningForTimeChanges()
            } else if eventArguments == "zone" {
                zoneEventSink = events
                startListeningForZoneChanges()
            }
        }
    }

    public func onCancel(withArguments arguments: Any?) {
        timeEventSink = nil
        zoneEventSink = nil
        timer?.invalidate()
    }
}

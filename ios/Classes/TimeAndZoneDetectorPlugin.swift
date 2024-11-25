import Flutter
import UIKit
import Foundation
import CoreLocation

public class TimeAndZoneDetectorPlugin: NSObject, FlutterPlugin {
    private var timeEventSink: FlutterEventSink?
    private var zoneEventSink: FlutterEventSink?
    private var previousTimeAutomatic = false
    private var previousZoneAutomatic = false
    private var timer: Timer?

    /*public static func register(with registrar: FlutterPluginRegistrar) {
       let channel = FlutterMethodChannel(name: "gov.pk.timezone/settings", binaryMessenger: registrar.messenger())
//       let timeEventChannel = FlutterEventChannel(name: "gov.pk.timezone/time/changes", binaryMessenger: registrar.messenger())
//       let zoneEventChannel = FlutterEventChannel(name: "gov.pk.timezone/zone/changes", binaryMessenger: registrar.messenger())
      let timeStreamHandler = TimeStreamHandler()
      let timeEventChannel = FlutterEventChannel(name: "gov.pk.timezone/time/changes", binaryMessenger: registrar.messenger())
      timeEventChannel.setStreamHandler(timeStreamHandler)

      let zoneStreamHandler = ZoneStreamHandler()
      let zoneEventChannel = FlutterEventChannel(name: "gov.pk.timezone/zone/changes", binaryMessenger: registrar.messenger())
      zoneEventChannel.setStreamHandler(zoneStreamHandler)

//           let instance = TimeAndZoneDetectorPlugin()


      let instance = TimeAndZoneDetectorPlugin()
      registrar.addMethodCallDelegate(instance, channel: channel)

      timeEventChannel.setStreamHandler(instance)
      zoneEventChannel.setStreamHandler(instance)
    }*/

    public static func register(with registrar: FlutterPluginRegistrar) {
            // Method channel
            let methodChannel = FlutterMethodChannel(name: "gov.pk.timezone/settings", binaryMessenger: registrar.messenger())
            let instance = TimeAndZoneDetectorPlugin()
            registrar.addMethodCallDelegate(instance, channel: methodChannel)

            // Event channels
            let timeStreamHandler = TimeStreamHandler()
            let timeEventChannel = FlutterEventChannel(name: "gov.pk.timezone/time/changes", binaryMessenger: registrar.messenger())
            timeEventChannel.setStreamHandler(timeStreamHandler)

            let zoneStreamHandler = ZoneStreamHandler()
            let zoneEventChannel = FlutterEventChannel(name: "gov.pk.timezone/zone/changes", binaryMessenger: registrar.messenger())
            zoneEventChannel.setStreamHandler(zoneStreamHandler)
        }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "isTimeAutomatic":
              result(isTimeAutomatic())
            case "isZoneAutomatic":
              (isZoneAutomatic(result: result))
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

    private func isZoneAutomatic(result: @escaping FlutterResult) {
        // iOS does not provide a direct API to check if automatic timezone is enabled.
        // For demonstration purposes, we'll use a heuristic: check if daylight saving time is enabled
         let timeZone = TimeZone.current
         print("Time Zone: \(timeZone.identifier)")
         print("Is DST: \(timeZone.isDaylightSavingTime())")
        
        let timeZoneIdentifiers = TimeZone.knownTimeZoneIdentifiers

        // Filter to find all time zones related to Pakistan
        let pakistanTimeZones = timeZoneIdentifiers.filter { $0.contains("Karachi") || $0.contains("Islamabad") }

        // Get the current device's time zone
        let currentDeviceTimeZone = TimeZone.current

        // Compare device time zone with Pakistan's time zones
        let currentDeviceTimeZoneIdentifier = currentDeviceTimeZone.identifier

        // Output the current device time zone
        print("Current Device Time Zone: \(currentDeviceTimeZoneIdentifier)")

        // Compare and output whether the current time zone is one of Pakistan's time zones
        if pakistanTimeZones.contains(currentDeviceTimeZoneIdentifier) {
            result(true)
        } else {
            result(true)
        }
//         return TimeZone.current.isDaylightSavingTime()
//        let checker = ZoneChecker()
//        checker.isAutomaticTimezoneEnabled { isAutomatic in
//            if let isAutomatic = isAutomatic {
//                print("Automatic Timezone is \(isAutomatic ? "enabled" : "disabled").")
//                if(isAutomatic){
//                    result(true)
//                }else{
//                    result(false)
//                }
//            } else {
//                print("Could not determine if Automatic Timezone is enabled.")
//                result(false)
//            }
//        }
//        return checker.isAutomaticTimezoneEnabled()
    }

    /* private func startListeningForTimeChanges() {
         *//* DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            let currentZoneAutomatic = self.isZoneAutomatic()

            if currentZoneAutomatic != self.previousZoneAutomatic {
                self.timeEventSink?(["time": currentTimeAutomatic])
                self.previousZoneAutomatic = currentZoneAutomatic
            }

            self.startListeningForTimeChanges()
        } *//*
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
    } */
}

/* extension TimeAndZoneDetectorPlugin: FlutterStreamHandler {
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
} */

/* class TimeStreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        // Start your time-related timer or logic here
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        // Stop your timer or cleanup here
        return nil
    }
}

class ZoneStreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        // Start your zone-related timer or logic here
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        // Stop your timer or cleanup here
        return nil
    }
} */
class TimeStreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var timer: Timer?

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        startListening()
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        stopListening()
        return nil
    }

    private func startListening() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let currentTimeAutomatic = UserDefaults.standard.bool(forKey: "AppleGlobalAutomaticTimeSetting")
            self.eventSink?(["time": currentTimeAutomatic])
        }
    }

    private func stopListening() {
        timer?.invalidate()
        timer = nil
        eventSink = nil
    }
}

// Separate stream handler for zone changes
class ZoneStreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var timer: Timer?

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        startListening()
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        stopListening()
        return nil
    }

    private func startListening() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            let timeZone = TimeZone.current
            print("Time Zone: \(timeZone.identifier)")
            print("Is DST: \(timeZone.isDaylightSavingTime())")
            guard let self = self else { return }
            print("Time Zone: \(timeZone.identifier)")
            print("Is DST: \(timeZone.isDaylightSavingTime())")
            let currentZoneAutomatic = TimeZone.current.isDaylightSavingTime()
            self.eventSink?(["zone": currentZoneAutomatic])
        }
    }

    private func stopListening() {
        timer?.invalidate()
        timer = nil
        eventSink = nil
    }
}

class ZoneChecker: NSObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    private var completion: ((Bool?) -> Void)?

    /// Checks if the timezone is set to automatic by comparing the system timezone with the one derived from the user's location.
    func isAutomaticTimezoneEnabled(completion: @escaping (Bool?) -> Void) {
        self.completion = completion
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers

        // Request permission for location services
        locationManager?.requestWhenInUseAuthorization()

        // Start location updates
        locationManager?.startUpdatingLocation()
    }
    
    func isAutomaticTimezoneEnabled() -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var isAutomatic: Bool? = nil
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        // Request permission for location services
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        
        DispatchQueue.global().async {
            if let location = self.locationManager?.location {
                // Use reverse geocoding to analyze location
                CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                    if let error = error {
                        print("Reverse geocoding error: \(error)")
                        isAutomatic = false
                    } else if let placemark = placemarks?.first {
                        // Analyze timezone information from the placemark
                        if let timeZone = placemark.timeZone {
                            isAutomatic = (timeZone.identifier == TimeZone.current.identifier)
                        } else {
                            isAutomatic = false
                        }
                    }
                    semaphore.signal() // Notify that the asynchronous task is complete
                }
            } else {
                isAutomatic = false
                semaphore.signal()
            }
        }
        
        // Wait until the async task is complete
        semaphore.wait()
        return isAutomatic ?? false
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            completion?(nil)
            cleanup()
            return
        }

        // Get the timezone from the user's current location
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self, let placemark = placemarks?.first else {
                self!.completion?(nil)
                self!.cleanup()
                return
            }

            // Compare the current timezone with the location-derived timezone
            let currentTimeZone = TimeZone.current
            let locationTimeZone = placemark.timeZone

            if let locationTimeZone = locationTimeZone {
                let isAutomatic = currentTimeZone.identifier == locationTimeZone.identifier
                self.completion?(isAutomatic)
            } else {
                self.completion?(nil) // Unable to determine
            }

            self.cleanup()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(nil) // Failed to get location
        cleanup()
    }

    private func cleanup() {
        locationManager?.stopUpdatingLocation()
        locationManager = nil
        completion = nil
    }
}


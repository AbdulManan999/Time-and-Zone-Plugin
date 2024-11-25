//import CoreLocation
//
//class ZoneChecker: NSObject, CLLocationManagerDelegate {
//    private var locationManager: CLLocationManager?
//    private var completion: ((Bool?) -> Void)?
//
//    /// Checks if the timezone is set to automatic by comparing the system timezone with the one derived from the user's location.
//    func isAutomaticTimezoneEnabled(completion: @escaping (Bool?) -> Void) {
//        self.completion = completion
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        locationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
//
//        // Request permission for location services
//        locationManager?.requestWhenInUseAuthorization()
//
//        // Start location updates
//        locationManager?.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {
//            completion?(nil)
//            cleanup()
//            return
//        }
//
//        // Get the timezone from the user's current location
//        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
//            guard let self = self, let placemark = placemarks?.first else {
//                self.completion?(nil)
//                self.cleanup()
//                return
//            }
//
//            // Compare the current timezone with the location-derived timezone
//            let currentTimeZone = TimeZone.current
//            let locationTimeZone = placemark.timeZone
//
//            if let locationTimeZone = locationTimeZone {
//                let isAutomatic = currentTimeZone.identifier == locationTimeZone.identifier
//                self.completion?(isAutomatic)
//            } else {
//                self.completion?(nil) // Unable to determine
//            }
//
//            self.cleanup()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        completion?(nil) // Failed to get location
//        cleanup()
//    }
//
//    private func cleanup() {
//        locationManager?.stopUpdatingLocation()
//        locationManager = nil
//        completion = nil
//    }
//}

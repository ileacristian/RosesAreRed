//
//  GPSLocationViewModel.swift
//  RosesAreRed
//
//  Created by Cristian Ilea on 11/08/2022.
//

import Foundation
import CoreLocation

enum GPSLocationError: Error {
    case unauthorized
    case unableToDetermineLocation

    func prettyErrorMessage() -> String {
        switch self {
            case .unauthorized:
                return "Error: GPS location was unauthorized."
            case .unableToDetermineLocation:
                return "Error: Unable to determine GPS Location."
        }
    }
}

class GPSLocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    @Published var location: CLLocation?
    @Published var locationError: String?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        locationManager.allowsBackgroundLocationUpdates = true
        fetchLocation()
    }

    func fetchLocation() {
        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            locationError = GPSLocationError.unauthorized.prettyErrorMessage()
        } else {
            locationError = GPSLocationError.unableToDetermineLocation.prettyErrorMessage()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .authorizedAlways,
                    .authorizedWhenInUse:
                manager.requestLocation()
            case .denied,
                    .notDetermined,
                    .restricted:
                locationError = GPSLocationError.unauthorized.prettyErrorMessage()
            @unknown default:
                locationError = GPSLocationError.unauthorized.prettyErrorMessage()
        }
    }
}

//
//  LocationManager.swift
//  KomootTracker
//
//  Created by Pau Ballart on 22/07/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol: class {
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func requestLocationPermission()
    func locationStatus() -> LocationStatus
    var delegate: LocationManagerDelegate? { get set }
    var isTrackingLocation: Bool { get set }
}

protocol LocationManagerDelegate: class {
    func didUpdateLocation(lat: Double, lon: Double)
    func didChangeAuthorizationStatus(status: LocationStatus)
}

enum LocationStatus: String {
    case notEnabled
    case notDetermined
    case authorized
    case rejected
}

class LocationManager: NSObject, LocationManagerProtocol {
    var locationManager: CLLocationManager
    weak var delegate: LocationManagerDelegate?
    var isTrackingLocation: Bool
    var lastLocation: CLLocation?
    
    override init() {
        locationManager = CLLocationManager()
        isTrackingLocation = false
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType = CLActivityType.fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.showsBackgroundLocationIndicator = true
    }
    
    func startUpdatingLocation() {
        print("Start udating location")
        locationManager.startUpdatingLocation()
        isTrackingLocation = true
    }
    
    func stopUpdatingLocation() {
        print("Stop udating location")
        locationManager.stopUpdatingLocation()
        isTrackingLocation = false
    }
    
    func requestLocationPermission() {
        if case .notDetermined = CLLocationManager.authorizationStatus() {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationStatus() -> LocationStatus {
        guard CLLocationManager.locationServicesEnabled() else {
            return .notEnabled
        }
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            return .notDetermined
        case .authorizedAlways:
            return .authorized
        default:
            return .rejected
        }
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        if let previousLocation = self.lastLocation, previousLocation.distance(from: newLocation) > 50 {
            self.lastLocation = newLocation
            delegate?.didUpdateLocation(lat: newLocation.coordinate.latitude, lon: newLocation.coordinate.longitude)
        } else {
            self.lastLocation = newLocation
            delegate?.didUpdateLocation(lat: newLocation.coordinate.latitude, lon: newLocation.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            delegate?.didChangeAuthorizationStatus(status: .authorized)
        default:
            delegate?.didChangeAuthorizationStatus(status: .rejected)
        }
    }
}

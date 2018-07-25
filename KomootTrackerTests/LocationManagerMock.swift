//
//  LocationManagerMock.swift
//  KomootTrackerTests
//
//  Created by Pau Ballart on 23/07/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import XCTest
@testable import KomootTracker

class LocationManagerMock: LocationManagerProtocol {
    
    var startUpdatingLocationCalled = false
    var stopUpdatingLocationCalled = false
    var requestLocationPermissionCalled = false
    var locationStatusCalled = false
    var nearestLocation = false
    
    var delegate: LocationManagerDelegate?
    var isTrackingLocation: Bool
    
    init() {
        isTrackingLocation = false
    }
    
    func startUpdatingLocation() {
        startUpdatingLocationCalled = true
    }
    
    func stopUpdatingLocation() {
        stopUpdatingLocationCalled = true
    }
    
    func requestLocationPermission() {
        requestLocationPermissionCalled = true
    }
    
    func locationStatus() -> LocationStatus {
        locationStatusCalled = true
        return .authorized
    }
    
    func nearestLocation(locations: [Location], from center: Location) -> Int? {
        nearestLocation = true
        return 0
    }
    
}

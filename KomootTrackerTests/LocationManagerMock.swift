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
    var nearestPhotoFromCalled = false
    
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
    
    func nearestPhotoFrom(latitude: Double, longitude: Double, photos: [PhotoDTO]) -> Photo {
        nearestPhotoFromCalled = true
        return Photo()
    }
    
}

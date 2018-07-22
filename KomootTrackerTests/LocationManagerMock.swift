//
//  LocationManagerMock.swift
//  KomootTrackerTests
//
//  Created by Pau Ballart on 22/07/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import XCTest
@testable import KomootTracker
import Moya

class LocationManagerMock: LocationManagerProtocol {
    
    var startUpdatingLocationCalled = false
    var stopUpdatingLocationCalled = false
    var requestLocationPermissionCalled = false
    var locationStatusCalled = false
    
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
    
    var delegate: LocationManagerDelegate?
    
    var isTrackingLocation: Bool
    
    
}

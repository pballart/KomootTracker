//
//  LocationManagerDelegateMock.swift
//  KomootTrackerTests
//
//  Created by Pau Ballart on 22/07/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import XCTest
@testable import KomootTracker

class LocationManagerDelegateMock: LocationManagerDelegate {
    
    var didUpdateLocationCalled = false
    var didChangeAuthorizationStatus: LocationStatus?
    
    func didUpdateLocation(lat: Double, lon: Double) {
        didUpdateLocationCalled = true
    }
    
    func didChangeAuthorizationStatus(status: LocationStatus) {
        didChangeAuthorizationStatus = status
    }
    
}



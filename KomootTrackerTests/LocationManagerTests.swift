//
//  LocationManagerTests.swift
//  KomootTrackerTests
//
//  Created by Pau Ballart on 23/07/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import XCTest
@testable import KomootTracker
import CoreLocation

class LocationManagerTests: XCTestCase {
    
    var locationManager: LocationManager!

    override func setUp() {
        locationManager = LocationManager()
    }
    
    func testInit() {
        XCTAssertNotNil(locationManager.locationManager)
        XCTAssertFalse(locationManager.isTrackingLocation)
        XCTAssert(locationManager.locationManager.allowsBackgroundLocationUpdates == true)
        XCTAssert(locationManager.locationManager.pausesLocationUpdatesAutomatically == false)
        XCTAssert(locationManager.locationManager.activityType == CLActivityType.fitness)
        XCTAssert(locationManager.locationManager.desiredAccuracy == kCLLocationAccuracyBest)
        XCTAssert(locationManager.locationManager.distanceFilter == locationManager.locationDistanceFilter)
        XCTAssert(locationManager.locationManager.showsBackgroundLocationIndicator == true)
    }
    
    func testStartUpdatingLocation() {
        locationManager.startUpdatingLocation()
        XCTAssertTrue(locationManager.isTrackingLocation)
    }
    
    func testStopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        XCTAssertFalse(locationManager.isTrackingLocation)
        XCTAssertNil(locationManager.lastLocation)
    }
    
    func testNearestPhotoFromLocation() {
        let centralLatitude: Double = 41.0
        let centralLongitude: Double = 2.0
        let location1 = (43.0, 2.0)
        let location2 = (42.1, 2.0)
        
        let nearestIndex = locationManager.nearestLocation(locations: [location1, location2], from: (centralLatitude, centralLongitude))
        XCTAssertNotNil(nearestIndex)
        XCTAssert(nearestIndex! == 1)
    }
    
    func testNearestPhotoFromLocationWithWrongLocation() {
        let centralLatitude: Double = 41.0
        let centralLongitude: Double = 2.0
        
        let nearestIndex = locationManager.nearestLocation(locations: [], from: (centralLatitude, centralLongitude))
        XCTAssertNil(nearestIndex)
    }
    
    func testDidUpdateLocation() {
        let delegateMock = LocationManagerDelegateMock()
        locationManager.delegate = delegateMock
        let location = CLLocation(latitude: 41.0, longitude: 2.0)
        locationManager.locationManager(locationManager.locationManager, didUpdateLocations: [location])
        XCTAssert(delegateMock.didUpdateLocationCalled)
        
        delegateMock.didUpdateLocationCalled = false
        let location2 = CLLocation(latitude: 31.0, longitude: 1.0)
        locationManager.locationManager(locationManager.locationManager, didUpdateLocations: [location2])
        XCTAssert(delegateMock.didUpdateLocationCalled)
    }
    
    func testDidChangeAuthorizationStatusAuthorized() {
        let delegateMock = LocationManagerDelegateMock()
        locationManager.delegate = delegateMock
        locationManager.locationManager(locationManager.locationManager, didChangeAuthorization: .authorizedAlways)
        XCTAssertNotNil(delegateMock.didChangeAuthorizationStatus)
        XCTAssert(delegateMock.didChangeAuthorizationStatus! == .authorized)
    }
    
    func testDidChangeAuthorizationStatusRejected() {
        let delegateMock = LocationManagerDelegateMock()
        locationManager.delegate = delegateMock
        locationManager.locationManager(locationManager.locationManager, didChangeAuthorization: .denied)
        XCTAssertNotNil(delegateMock.didChangeAuthorizationStatus)
        XCTAssert(delegateMock.didChangeAuthorizationStatus! == .rejected)
    }
}

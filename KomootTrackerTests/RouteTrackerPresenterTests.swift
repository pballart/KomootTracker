//
//  RouteTrackerPresenterTests.swift
//  KomootTrackerTests
//
//  Created by Pau Ballart on 23/07/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import XCTest
@testable import KomootTracker

class RouteTrackerPresenterTests: XCTestCase {
    
    var view: RouteTrackerViewMock!
    var provider: FlickrServiceMock!
    var locationManager: LocationManagerMock!
    var presenter: RouteTrackerPresenter!

    override func setUp() {
        view = RouteTrackerViewMock()
        provider = FlickrServiceMock()
        locationManager = LocationManagerMock()
        presenter = RouteTrackerPresenter(view: view, provider: provider, locationManager: locationManager)
    }
    
    func testStartButtonPressedShouldStart() {
        presenter.startButtonPressed()
        XCTAssertFalse(presenter.isPendingToStart)
        XCTAssert(locationManager.startUpdatingLocationCalled)
        XCTAssert(view.updateStartButtonCalled)
    }
    
    func testStartButtonPressedShouldStop() {
        locationManager.isTrackingLocation = true
        presenter.startButtonPressed()
        XCTAssert(locationManager.stopUpdatingLocationCalled)
        XCTAssert(view.updateStartButtonCalled)
    }
    
    func testDidUpdateLocation() {
        let latitude: Double = 41.0
        let longitude: Double = 2.0
        presenter.didUpdateLocation(lat: latitude, lon: longitude)
        XCTAssert(provider.searchPhotoCalled)
    }
    
    func testDidChangeAuthorizationStatus() {
        presenter.isPendingToStart = true
        presenter.didChangeAuthorizationStatus(status: .authorized)
        XCTAssertFalse(presenter.isPendingToStart)
        XCTAssert(locationManager.startUpdatingLocationCalled)
        XCTAssert(view.updateStartButtonCalled)
    }

}

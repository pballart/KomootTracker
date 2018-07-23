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
    
    var view: RouteTrackerViewProtocol!
    var provider: FlickrServiceProtocol!
    var locationManager: LocationManagerProtocol!
    var presenter: RouteTrackerPresenter!

    override func setUp() {
        view = RouteTrackerViewMock()
        provider = FlickrServiceMock()
        presenter = RouteTrackerPresenter(view: view, provider: provider)
    }

}

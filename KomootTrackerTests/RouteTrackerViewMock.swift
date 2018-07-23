//
//  RouteTrackerViewMock.swift
//  KomootTrackerTests
//
//  Created by Pau Ballart on 23/07/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import XCTest
@testable import KomootTracker

class RouteTrackerViewMock: RouteTrackerViewProtocol {
    
    var updateStartButtonCalled = false
    var showEnableLocationServiesAlertCalled = false
    var showAuthorizeLocationServiesAlertCalled = false
    
    func updateStartButton(title: String) {
        updateStartButtonCalled = true
    }
    
    func showEnableLocationServiesAlert() {
        showEnableLocationServiesAlertCalled = true
    }
    
    func showAuthorizeLocationServiesAlert() {
        showAuthorizeLocationServiesAlertCalled = true
    }
    
    
}

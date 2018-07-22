//
//  KomootTrackerTests.swift
//  KomootTrackerTests
//
//  Created by Pau Ballart on 21/07/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import XCTest
@testable import KomootTracker
import Moya

class KomootTrackerTests: XCTestCase {
    
    func testAPICallSucceeds() {
        let networkExpectation = expectation(description: "networktest")
        let stubbingProvider = MoyaProvider<SearchEndpoint>(stubClosure: MoyaProvider.immediatelyStub)
        let provider = FlickrService(provider: stubbingProvider)
        let minDate = Date().addingTimeInterval(-3600*24*365).timeIntervalSince1970
        provider.searchPhotoBy(latitude: 41.376172, longitude: 2.148466, minDate: minDate) { (result) in
            switch result {
            case .success(let searchDTO):
                XCTAssertNotNil(searchDTO)
                XCTAssert(searchDTO.photos.photos.count == 1)
            case .failure(let error):
                XCTFail(error.localizedDescription)
                break
            }
            networkExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testAPICallFails() {
        let networkExpectation = expectation(description: "networktest")
        
        let endpointClosure = { (target: SearchEndpoint) -> Endpoint<SearchEndpoint> in
            return Endpoint(url: target.baseURL.absoluteString,
                            sampleResponseClosure: {.networkResponse(500, target.sampleData)},
                            method: target.method, task: target.task, httpHeaderFields: target.headers)
        }
        let stubbingProvider = MoyaProvider<SearchEndpoint>(endpointClosure: endpointClosure,
                                                            stubClosure: MoyaProvider.immediatelyStub)
        let provider = FlickrService(provider: stubbingProvider)
        let minDate = Date().addingTimeInterval(-3600*24*356).timeIntervalSince1970
        provider.searchPhotoBy(latitude: 41.376172, longitude: 2.148466, minDate: minDate) { (result) in
            switch result {
            case .success:
                XCTFail("Call should have failed")
                networkExpectation.fulfill()
            case .failure(let error):
                XCTAssert(error == .serverInternalError)
                break
            }
            networkExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}

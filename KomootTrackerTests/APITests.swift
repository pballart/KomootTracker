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
import RxSwift

class APITests: XCTestCase {
    
    //Fetch images taken in the latests 6 months
    let minDate = Date().addingTimeInterval(-3600*24*30*6).timeIntervalSince1970
    let disposeBag = DisposeBag()
    
    func testAPICallSucceeds() {
        let networkExpectation = expectation(description: "networktest")
        let stubbingProvider = MoyaProvider<SearchEndpoint>(stubClosure: MoyaProvider.immediatelyStub)
        let provider = FlickrService(provider: stubbingProvider)
        
        provider.searchPhotoBy(latitude: 41.376172, longitude: 2.148466, minDate: minDate).subscribe(onNext: { (responseDTO) in
            XCTAssertNotNil(responseDTO)
            XCTAssert(responseDTO.photos.photos.count == 1)
            guard let photoDTO = responseDTO.photos.photos.first else {
                XCTFail("PhotoDTO was nil")
                return
            }
            let photo = Photo().loadValue(id: photoDTO.id, url: photoDTO.imageURL, fetchDate: Date())
            XCTAssert(photo.id == photoDTO.id)
            XCTAssert(photo.url == "https://farm\(photoDTO.farm).staticflickr.com/\(photoDTO.server)/\(photoDTO.id)_\(photoDTO.secret).jpg")
            networkExpectation.fulfill()
        }, onError: { error in
            XCTAssertNotNil(error)
            networkExpectation.fulfill()
        }).disposed(by: disposeBag)
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
        
        provider.searchPhotoBy(latitude: 41.376172, longitude: 2.148466, minDate: minDate).subscribe(onNext: { (responseDTO) in
            XCTFail("Call should have failed")
            networkExpectation.fulfill()
        }, onError: { (error) in
            XCTAssertNotNil(error)
            networkExpectation.fulfill()
        }).disposed(by: disposeBag)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}

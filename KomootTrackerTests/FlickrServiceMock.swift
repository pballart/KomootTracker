//
//  FlickrServiceMock.swift
//  KomootTrackerTests
//
//  Created by Pau Ballart on 23/07/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import XCTest
@testable import KomootTracker
import RxSwift

class FlickrServiceMock: FlickrServiceProtocol {
    var searchPhotoCalled = false
    func searchPhotoBy(latitude: Double, longitude: Double, minDate: Double) -> Observable<FlickrPhotosResponseDTO> {
        searchPhotoCalled = true
        return Observable.just(FlickrPhotosResponseDTO(photos: SearchPhotoDTO(page: nil, pages: nil, perPage: nil, total: nil, photos: []), stat: ""))
    }
    
    
}

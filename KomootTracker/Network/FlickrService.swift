//
//  FlickrService.swift
//  KomootTracker
//
//  Created by Pau Ballart on 21/07/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import Foundation
import Moya
import Result
import RxSwift

protocol FlickrServiceProtocol {
    func searchPhotoBy(latitude: Double,
                       longitude: Double,
                       minDate: Double) -> Observable<FlickrPhotosResponseDTO>
}

class FlickrService: FlickrServiceProtocol {
    private let disposeBag = DisposeBag()
    private let flickrProvider: MoyaProvider<SearchEndpoint>
    
    init(provider: MoyaProvider<SearchEndpoint>) {
        flickrProvider = provider
    }
    
    func searchPhotoBy(latitude: Double,
                       longitude: Double,
                       minDate: Double) -> Observable<FlickrPhotosResponseDTO> {
        let endpoint: SearchEndpoint = .searchPhoto(lat: latitude, lon: longitude, minDate: minDate)
        return flickrProvider.rx.request(endpoint).filterSuccessfulStatusCodes().asObservable().map(FlickrPhotosResponseDTO.self)
    }
}

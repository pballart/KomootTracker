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
    func retrievePhotoFromLocation(latitude: Double,
                                   longitude: Double,
                         onResult: @escaping (_ result: Result<FlickrPhotosResponseDTO, NetworkError> ) -> Void)
}

class FlickrService {
    let disposeBag = DisposeBag()
    let flickrProvider: MoyaProvider<SearchEndpoint>
    
    init(provider: MoyaProvider<SearchEndpoint>) {
        flickrProvider = provider
    }
    
    func searchPhotoBy(latitude: Double,
                       longitude: Double,
                       minDate: Double,
                         onResult: @escaping (_ result: Result<FlickrPhotosResponseDTO, NetworkError> ) -> Void) {
        let endpoint: SearchEndpoint = .searchPhoto(lat: latitude, lon: longitude, minDate: minDate)
        flickrProvider.rx.request(endpoint).filterSuccessfulStatusCodes().subscribe(onSuccess: { response in
            do {
                _ = try response.filterSuccessfulStatusCodes()
                let decoder = JSONDecoder()
                let responseDTO = try decoder.decode(FlickrPhotosResponseDTO.self, from: response.data)
                onResult(.success(responseDTO))
            } catch MoyaError.statusCode {
                onResult(.failure(NetworkError.serverInternalError))
            } catch {
                onResult(.failure(NetworkError.responseFormatError))
            }
        }) { error in
            if let err = error as? MoyaError {
                onResult(.failure(NetworkError.translateError(err)))
            } else {
                onResult(.failure(.responseFormatError))
            }
            }.disposed(by: disposeBag)
    }
}

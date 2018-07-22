//
//  SearchEndpoint.swift
//  KomootTracker
//
//  Created by Pau Ballart on 21/07/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import Foundation
import Moya

enum SearchEndpoint {
    case searchPhoto(lat: Double, lon: Double, minDate: Double)
}

extension SearchEndpoint: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.flickr.com")!
    }
    
    var path: String {
        switch self {
        case .searchPhoto:
            return "/services/rest"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchPhoto:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .searchPhoto(let lat, let lon, let minDate):
            return ["method": "flickr.photos.search",
                    "format": "json",
                    "nojsoncallback": 1,
                    "api_key": FLICKR_API_KEY,
                    "per_page": 1,
                    "lat": lat,
                    "lon": lon,
                    "min_taken_date": minDate]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .searchPhoto:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        switch self {
        case .searchPhoto:
            let sampleRespone = """
                                {
                                    "photos": {
                                        "page": 1,
                                        "pages": 1572,
                                        "perpage": 250,
                                        "total": "392923",
                                        "photo": [
                                            {
                                                "id": "42610932595",
                                                "owner": "89853750@N00",
                                                "secret": "5861b51bab",
                                                "server": "1806",
                                                "farm": 2,
                                                "title": "AntonelloFranzil-2048-WM-DSC00619",
                                                "ispublic": 1,
                                                "isfriend": 0,
                                                "isfamily": 0
                                            }
                                        ]
                                    },
                                    "stat": "ok"
                                }
                                """
            return sampleRespone.utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .searchPhoto:
            return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
        }
    }
    
    var headers: [String: String]? {
        return [:]
    }
    
}

private extension String {
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

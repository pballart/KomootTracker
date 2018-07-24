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
    
    var parameters: [String: Any] {
        switch self {
        case .searchPhoto(let lat, let lon, let minDate):
            return ["method": "flickr.photos.search",
                    "format": "json",
                    "nojsoncallback": 1,
                    "api_key": FLICKR_API_KEY,
                    "lat": lat,
                    "lon": lon,
                    "radius": 0.05,
                    "has_geo": 1,
                    "media": "photos",
                    "extras": "geo",
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
                                                "id": "43362704372",
                                                "owner": "31526369@N00",
                                                "secret": "1cc7bf9f46",
                                                "server": "1765",
                                                "farm": 2,
                                                "title": "Cal anar-hi, anar-hi i anar-hi, Sants-Montjuïc (Barcelona, el Barcelonès)",
                                                "ispublic": 1,
                                                "isfriend": 0,
                                                "isfamily": 0,
                                                "latitude": "41.379277",
                                                "longitude": "2.144343",
                                                "accuracy": "16",
                                                "context": 0,
                                                "place_id": "RcSZk8ZTUrjzcdMOkA",
                                                "woeid": "20220091",
                                                "geo_is_family": 0,
                                                "geo_is_friend": 0,
                                                "geo_is_contact": 0,
                                                "geo_is_public": 1
                                            },
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
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }
    }
    
    var headers: [String: String]? {
        return [:]
    }
    
}

private extension String {
    var utf8Encoded: Data {
        return data(using: .utf8) ?? Data()
    }
}

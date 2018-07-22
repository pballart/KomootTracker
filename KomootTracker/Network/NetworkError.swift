//
//  NetworkError.swift
//  KomootTracker
//
//  Created by Pau Ballart on 21/07/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import Foundation
import Moya

public enum NetworkError: Swift.Error, Equatable {
    case invalidParamsError
    case connectionError
    case timeOutError
    case cancelledError
    case responseFormatError
    case serverInternalError
    case clientError(message: String?, internalCode: String?)
    
    public static func translateError(_ moyaError: MoyaError) -> NetworkError {
        switch moyaError {
        case .statusCode(let response):
            switch response.statusCode {
            case 500...599:
                return NetworkError.serverInternalError
            default:
                return NetworkError.clientError(message: "Invalid status code \(response.statusCode)",
                    internalCode: "\(response.statusCode)")
            }
        case .imageMapping:
            return NetworkError.responseFormatError
        case .jsonMapping:
            return NetworkError.responseFormatError
        case .stringMapping:
            return NetworkError.responseFormatError
        default:
            return NetworkError.responseFormatError
        }
    }
    
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidParamsError, .invalidParamsError), (.connectionError, .connectionError),
             (.timeOutError, .timeOutError), (.cancelledError, .cancelledError),
             (.responseFormatError, .responseFormatError), (.serverInternalError, .serverInternalError):
            return true
        case (.clientError(_, let internalCodeLeft), .clientError(_, let internalCodeRight)):
            return internalCodeLeft == internalCodeRight
        default:
            return false
        }
    }
}

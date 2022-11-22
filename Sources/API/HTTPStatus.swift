//
//  HTTPStatus.swift
//  API
//
//  Created by Chris Pflepsen on 11/2/22.
//

import Foundation

public enum HTTPStatus {
    case success
    case created
    case noContent
    case badRequest
    case unauthorized
    case forbidden
    case serverError
    case unknown
    
    var isSuccess: Bool {
        switch self {
        case .success, .created, .noContent:
            return true
        default:
            return false
        }
    }
    
    init(statusCode: Int) {
        switch statusCode {
        case 201:
            self = .created
        case 204:
            self = .noContent
        case 200..<300:
            self = .success
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 500..<600:
            self = .serverError
        default:
            self = .unknown
        }
    }
    
}

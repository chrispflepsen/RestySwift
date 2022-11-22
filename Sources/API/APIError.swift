//
//  APIError.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

public enum APIError: Error {
    case unauthorized
    case forbidden
    case unableToBuildRequest
    case invalidStatus(HTTPStatus)
    case invalidJSON(DecodingError)
    case unknown
    case reAuth
}

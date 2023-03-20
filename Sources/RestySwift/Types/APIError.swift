//
//  APIError.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

public enum APIError: Error {
    case unableToBuildRequest
    case invalidHTTPStatus(HTTPStatus)
    case invalidJSON(DecodingError)
    case unsuported
    case unknown
}

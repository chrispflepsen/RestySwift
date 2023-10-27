//
//  APIError.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

/// Custom RestySwift Errors
public enum APIError: Error {
    case unableToBuildRequest
    case invalidHTTPStatus(APIResponse)
    case invalidJSON(DecodingError)
    case unsupported
    case unknown
}

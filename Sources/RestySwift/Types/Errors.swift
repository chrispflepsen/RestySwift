//
//  Errors.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

/// Custom RestySwift Errors
public enum APIError: Error {
    /// There was an error building the request.
    case unableToBuildRequest
    
    /// There was an error building a stub response.
    case unableToStubResponse
    
    /// There was an error encoding the request body.
    case encodingError
    
    /// The response contained an error http status code.
    case invalidHTTPStatus(Response)
    
    /// There was an error decoding the JSON response.
    case invalidJSON(DecodingError)
    
    /// The operation is unsupported.
    case unsupported
    
    /// An unknown error has occurred.
    case unknown
}

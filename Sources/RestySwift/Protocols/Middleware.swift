//
//  Middleware.swift
//  
//
//  Created by Chris Pflepsen on 10/25/23.
//

import Foundation

/// A protocol that defines the behavior of middleware components in an API request pipeline.
public protocol Middleware {
    /// Intercept and process an API request and response.
    ///
    /// - Parameters:
    ///   - request: The APIRequest to be intercepted.
    ///   - next: A closure that represents the next middleware or the final network call.
    /// - Returns: An API response after processing the request.
    /// - Throws: An error if the interception or API request processing encounters a problem.
    func intercept<T: APIRequest>(
        _ request: T,
        next: (T) async throws -> APIResponse
    ) async throws -> APIResponse
}

/// An object representing the response received from an API call.
public struct APIResponse {
    /// URL of the request.
    let url: URL?

    /// HTTP status code of the response.
    let statusCode: HTTPStatus

    /// The headers included in the response.
    let headers: Headers

    /// The raw body data in the response
    let data: Data

    init(data: Data, response: URLResponse) {
        self.url = response.url
        self.statusCode = response.httpStatus
        self.headers = response.headers
        self.data = data
    }
}

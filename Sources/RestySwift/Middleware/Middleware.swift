//
//  Middleware.swift
//  
//
//  Created by Chris Pflepsen on 10/25/23.
//

import Foundation

/// A protocol that defines the behavior of middleware components in an API request pipeline.
public protocol Middleware {
    /// Intercept a `Request` and modify it before it is performed.
    ///
    /// - Parameter request: The request that can be modified and then will be performed.
    /// - Returns: The request to be performed.
    /// - Throws: Will throw an error if the request is unable to be modified.
    ///
    func interceptRequest<T: Request>(_ request: MutableRequest<T>) async throws -> MutableRequest<T>
    
    /// Intercept a `response` and modify it before it is returned.
    ///
    /// - Parameter response: The `Response` that can be modified and then will be returned as the result of the request.
    /// - Returns: The response to be returned.
    /// - Throws: Will throw an error if the response is unable to be modified.
    ///
    func interceptResponse(_ response: Response) async throws -> Response
}

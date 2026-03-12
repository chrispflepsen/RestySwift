//
//  APIDataProvider.swift
//  
//
//  Created by Chris Pflepsen on 10/26/23.
//

import Foundation

/// A protocol that executes HTTP requests and returns their responses.
///
public protocol HTTPClient {
    /// Asynchronously performs a `URLRequest`.
    ///
    /// - Parameters:
    ///  - encoder: The `JSONEncoder` used to encode the request.
    ///  - request: The `URLRequest` that will be performed.
    /// - Returns: A tuple containing the `Data` returned and the `URLResponse`.
    /// - Throws: An error if the request fails.
    ///
    func perform(encoder: JSONEncoder, request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPClient {
    public func perform(encoder: JSONEncoder, request: URLRequest) async throws -> (Data, URLResponse) {
        return try await data(for: request)
    }
}

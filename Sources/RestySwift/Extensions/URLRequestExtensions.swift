//
//  URLRequest+Extensions.swift
//  API
//
//  Created by Chris Pflepsen on 11/2/22.
//

import Foundation

extension URLRequest {

    /// Initializes a `URLRequest` from a `Request`.
    ///
    /// - Parameters:
    ///  - request: The `Request` object used to build the majority of the `URLRequest`.
    ///  - baseUrl: The base `URL` for the request.
    ///  - headers: The `Headers` that will be added to the request.
    ///  - parameters: The `Parameters` that will be added to the request.
    ///  - encoder: The `JSONEncoder` used to encode the body of the request.
    ///
    init<T: Request>(
        request: T,
        baseUrl: String,
        headers: Headers,
        parameters: Parameters,
        encoder: JSONEncoder
    ) throws {
        let url = try URLBuilder.build(
            baseUrl,
            path: PathComponent(request.path).path,
            parameters: parameters
        )
        self.init(url: url)
        self.injectHeaders(headers)
        self.httpMethod = request.httpMethod.rawValue
        do {
            self.httpBody = try encoder.encode(request.body)
        } catch {}
    }
    
    /// Adds the headers to the request.
    ///
    /// - Parameter headers: The `Headers` to be added to the request.
    ///
    private mutating func injectHeaders(_ headers: Headers) {
        for (key, value) in headers {
            self.addValue(value, forHTTPHeaderField: key)
        }
    }
}

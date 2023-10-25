//
//  Middleware.swift
//  
//
//  Created by Chris Pflepsen on 10/25/23.
//

import Foundation

public protocol Middleware {
    func intercept<T: APIRequest>(
        _ request: T,
        body: T.Body?,
        baseURL: URL,
        operationID: String,
        next: (T, T.Body?, URL) async throws -> (T, T.Body?)
    ) async throws -> (T, T.Body?)
}

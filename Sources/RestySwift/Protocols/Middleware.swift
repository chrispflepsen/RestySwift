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
        next: (T) async throws -> APIResponse
    ) async throws -> APIResponse
}

public struct APIResponse {
    let url: URL?
    let statusCode: HTTPStatus
    let headers: Headers
    let data: Data

    init(data: Data, response: URLResponse) {
        self.url = response.url
        self.statusCode = response.httpStatus
        self.headers = response.headers
        self.data = data
    }
}

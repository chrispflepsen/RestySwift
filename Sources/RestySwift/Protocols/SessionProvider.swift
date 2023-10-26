//
//  SessionProvider.swift
//  
//
//  Created by Chris Pflepsen on 3/20/23.
//

import Foundation

protocol APIDataProvider {
    func data(api: API, request: URLRequest) async throws -> (Data, URLResponse)
    func upload(api: API, request: URLRequest, from: Data) async throws -> (Data, URLResponse)
}

extension URLSession: APIDataProvider {
    func data(api: API, request: URLRequest) async throws -> (Data, URLResponse) {
        return try await data(for: request)
    }

    func upload(api: API, request: URLRequest, from: Data) async throws -> (Data, URLResponse) {
        return try await upload(for: request, from: from)
    }
}

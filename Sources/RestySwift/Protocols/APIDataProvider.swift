//
//  APIDataProvider.swift
//  
//
//  Created by Chris Pflepsen on 10/26/23.
//

import Foundation

protocol APIDataProvider {
    func data(api: API, request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: APIDataProvider {
    func data(api: API, request: URLRequest) async throws -> (Data, URLResponse) {
        return try await data(for: request)
    }
}

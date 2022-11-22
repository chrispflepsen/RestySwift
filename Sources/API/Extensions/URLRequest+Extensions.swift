//
//  URLRequest+Extensions.swift
//  API
//
//  Created by Chris Pflepsen on 11/2/22.
//

import Foundation

extension URLRequest {
    
    init(baseUrl: URL, request: some APIRequest) throws {
        guard let url = URL(string: request.path, relativeTo: baseUrl) else {
            throw APIError.unableToBuildRequest
        }
        
        self.init(url: url)
    }
    
    mutating func injectHeaders(_ headers: [String: String]) {
        for (key, value) in headers {
            self.addValue(value, forHTTPHeaderField: key)
        }
    }
}

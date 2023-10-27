//
//  URLRequest+Extensions.swift
//  API
//
//  Created by Chris Pflepsen on 11/2/22.
//

import Foundation

extension URLRequest {

    init<T: APIRequest>(request: T,
                        baseUrl: String,
                        headers: Headers,
                        parameters: Parameters,
                        encoder: JSONEncoder) throws {
        let url = try URLBuilder.build(baseUrl,
                                       path: PathComponent(request.path).path,
                                       parameters: parameters)
        self.init(url: url)
        self.injectHeaders(headers)
        self.httpMethod = request.httpMethod.rawValue
        if let body = request.body {
            self.httpBody = try encoder.encode(body)
        }
    }
    
    mutating func injectHeaders(_ headers: Headers) {
        for (key, value) in headers {
            self.addValue(value, forHTTPHeaderField: key)
        }
    }
}

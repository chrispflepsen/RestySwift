//
//  URLRequest+Extensions.swift
//  API
//
//  Created by Chris Pflepsen on 11/2/22.
//

import Foundation

extension URLRequest {

    init<T: APIRequest>(request: T,
                        api: API,
                        versionProvider: VersionProvider?,
                        authProvider: AuthenticationProvider?) throws {
        let urlPath = (versionProvider?.versionString(forRequest: request) ?? "") + request.path
        let url = try URLBuilder.build(api.baseUrl,
                                       path: urlPath,
                                       parameters: request.parameters)
        self.init(url: url)
        self.injectHeaders(request.headers ?? api.headers)
        self.httpMethod = request.httpMethod.rawValue
        if let body = request.body {
            self.httpBody = try api.encoder.encode(body)
        }
        if let authProvider = authProvider {
            authProvider.injectCredentials(forRequest: request, urlRequest: &self)
        }
    }
    
    mutating func injectHeaders(_ headers: [String: String]) {
        for (key, value) in headers {
            self.addValue(value, forHTTPHeaderField: key)
        }
    }
}

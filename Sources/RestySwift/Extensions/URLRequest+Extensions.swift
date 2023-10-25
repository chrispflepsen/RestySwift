//
//  URLRequest+Extensions.swift
//  API
//
//  Created by Chris Pflepsen on 11/2/22.
//

import Foundation

extension URLRequest {

    init<T: APIRequest>(request: T,
                        body: T.Response?,
                        api: API) throws {
        
        let pathComponent = PathComponent(versionProvider?.versionString(forRequest: request)) + PathComponent(request.path)

        let url = try URLBuilder.build(api.baseUrl,
                                       path: pathComponent.path,
                                       parameters: request.parameters)
        self.init(url: url)
        var headers = api.headers
        if let requestHeaders = request.headers {
            // Combine the headers, taking the request headers over the api headers
            headers.merge(requestHeaders) { _, new in new }
        }
        self.injectHeaders(headers)
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

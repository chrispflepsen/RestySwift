//
//  URLResponse.swift
//  API
//
//  Created by Chris Pflepsen on 11/2/22.
//

import Foundation

extension URLResponse {
    
    /// The `HTTPStatus` of the response.
    var httpStatus: HTTPStatus {
        guard let httpResponse = self as? HTTPURLResponse else {
            return .unknown
        }
        return HTTPStatus(statusCode: httpResponse.statusCode)
    }

    /// The `Headers` included in the response.
    var headers: Headers {
        var headers = [String: String]()
        guard let httpResponse = self as? HTTPURLResponse else {
            return headers
        }
        httpResponse.allHeaderFields.forEach { (key, value) in
            if let key = key as? String,
                let value = value as? String {
                headers[key] = value
            }
        }
        return headers
    }
}

extension HTTPURLResponse {
    convenience init?(
        request: URLRequest,
        statusCode: HTTPStatus = .success
    ) {
        guard let url = request.url else { return nil }
        self.init(
            url: url,
            statusCode: statusCode.statusCode,
            httpVersion: nil,
            headerFields: nil
        )
    }
}

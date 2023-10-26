//
//  URLResponse.swift
//  API
//
//  Created by Chris Pflepsen on 11/2/22.
//

import Foundation

extension URLResponse {
    var httpStatus: HTTPStatus {
        guard let httpResponse = self as? HTTPURLResponse else {
            return .unknown
        }
        return HTTPStatus(statusCode: httpResponse.statusCode)
    }

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

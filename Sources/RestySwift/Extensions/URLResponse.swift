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
}

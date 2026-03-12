//
//  Response.swift
//  RestySwift
//
//  Created by Chris Pflepsen on 3/13/26.
//

import Foundation

/// An object representing the response received from an API call used by middleware.
public class Response {
    /// URL of the request.
    let url: URL?

    /// HTTP status code of the response.
    var statusCode: HTTPStatus

    /// The headers included in the response.
    var headers: Headers

    /// The raw body data in the response
    var data: Data

    /// initialize with the results from a URLSession request
    init(data: Data, response: URLResponse) {
        self.url = response.url
        self.statusCode = response.httpStatus
        self.headers = response.headers
        self.data = data
    }
}

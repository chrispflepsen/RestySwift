//
//  Headers.swift
//  
//
//  Created by Chris Pflepsen on 10/25/23.
//

import Foundation

/// HTTP header representation `[String: String]`
public typealias Headers = [String: String]

extension Headers {
    init(defaultHeaders: Headers?,
         requestHeaders: Headers?) {
        var headers = defaultHeaders ?? [:]
        if let additionalHeaders = requestHeaders {
            // Combine the headers, taking the request headers over the default headers
            headers.merge(additionalHeaders) { _, new in new }
        }
        self = headers
    }
}

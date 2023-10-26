//
//  Parameters.swift
//  
//
//  Created by Chris Pflepsen on 10/25/23.
//

import Foundation

public typealias Parameters = [String: QueryParameter]

extension Parameters {
    init(defaultParameters: Parameters?,
         requestParameters: Parameters?) {
        var parameters = defaultParameters ?? [:]
        if let additionalParameters = requestParameters {
            // Combine the headers, taking the request headers over the default headers
            parameters.merge(additionalParameters) { _, new in new }
        }
        self = parameters
    }
}

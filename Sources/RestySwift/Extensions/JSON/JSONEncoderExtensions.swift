//
//  JSONEncoderExtensions.swift
//
//
//  Created by Chris Pflepsen on 10/26/23.
//

import Foundation

public extension JSONEncoder {
    /// An instance of JSONEncoder configured for encoding camelCase properties to snake_case JSON keys
    static var snakeCase: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}

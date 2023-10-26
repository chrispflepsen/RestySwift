//
//  JSONDecoderExtensions.swift
//
//
//  Created by Chris Pflepsen on 10/26/23.
//

import Foundation

public extension JSONDecoder {
    /// An instance of JSONDecoder configured for decoding snake_case JSON keys to camelCase properties
    static var snakeCase: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

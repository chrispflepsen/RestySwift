//
//  Encoders.swift
//  
//
//  Created by Chris Pflepsen on 10/25/23.
//

import Foundation

extension JSONEncoder {
    var snakeCase: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}

extension JSONDecoder {
    var snakeCase: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

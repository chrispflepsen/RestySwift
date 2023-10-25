//
//  Encoders.swift
//
//
//  Created by Chris Pflepsen on 10/25/23.
//

import Foundation

public extension JSONEncoder {
    static var snakeCase: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}

public extension JSONDecoder {
    static var snakeCase: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

struct MyApi: API {
    var cacheProvider: CacheProvider?
    
    var baseUrl: String { "https://mysite.test" }
    let encoder: JSONEncoder = .snakeCase
}

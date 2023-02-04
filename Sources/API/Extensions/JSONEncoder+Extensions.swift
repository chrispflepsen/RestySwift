//
//  File.swift
//  
//
//  Created by Chris Pflepsen on 2/4/23.
//

import Foundation

enum EncoderError: Error {
    case unableToUrlEncode
}

extension JSONEncoder {

    func urlEncode(_ encodable: Encodable) throws -> String {
        let data = try encode(encodable)
        guard let json = String(data: data, encoding: .utf8),
              let encoded = json.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw EncoderError.unableToUrlEncode
        }
        return encoded
    }

}

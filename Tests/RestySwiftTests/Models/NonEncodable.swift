//
//  NonEncodable.swift
//  RestySwift
//
//  Created by Chris Pflepsen on 3/15/26.
//

import Testing

@testable import RestySwift

struct NonEncodable: Encodable {
    func encode(to encoder: Encoder) throws {
        throw APIError.encodingError
    }
}

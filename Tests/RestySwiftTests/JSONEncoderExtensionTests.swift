//
//  JSONEncoderExtensionTests.swift
//  RestySwift
//
//  Created by Chris Pflepsen on 3/14/26.
//

import Foundation
import Testing

@testable import RestySwift

struct SnakeCaseEncodingRequest: Encodable {
    let snakeName: String
}

struct SnakeCaseEncodingResponse: Decodable {
    let snake_name: String
}

struct JSONEncoderExtensionTests {

    // Test that a camel case object is encoded as snake case.
    @Test func snakeCaseEncoding() async throws {
        let encoder = JSONEncoder.snakeCase
        let decoder = JSONDecoder()

        let data = try encoder.encode(SnakeCaseEncodingRequest(snakeName: "Mr. Conda"))
        let result = try decoder.decode(SnakeCaseEncodingResponse.self, from: data)
        #expect(result.snake_name == "Mr. Conda")
    }
}

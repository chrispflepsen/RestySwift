//
//  JSONDecoderExtensionTests.swift
//  RestySwift
//
//  Created by Chris Pflepsen on 3/14/26.
//

import Foundation
import Testing

@testable import RestySwift

struct SnakeCaseDecodingRequest: Encodable {
    let snake_name: String
}

struct SnakeCaseDecodingResponse: Decodable {
    let snakeName: String
}

struct JSONDecoderExtensionTests {

    /// Test that a snake case encoded object is correctly decoded by `JSONDecoder.snakeCase` to camel case.
    @Test func snakeCaseDecoding() async throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder.snakeCase
        
        let data = try encoder.encode(SnakeCaseDecodingRequest(snake_name: "Mr. Conda"))
        let result = try decoder.decode(SnakeCaseDecodingResponse.self, from: data)
        #expect(result.snakeName == "Mr. Conda")
    }
}

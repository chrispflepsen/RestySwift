//
//  ResponseProviderTests.swift
//  RestySwift
//
//  Created by Chris Pflepsen on 3/14/26.
//

import Foundation
import Testing

@testable import RestySwift

struct ResponseProviderTests {
    
    let subject = URLSession.shared

    /// Test that using `URLSession` as a `HTTPClient` returns actual data.
    @Test func urlSessionResponseProvider() async throws {
        let url = try #require(URL(string: "https://wikipedia.org"))
        let urlRequest = URLRequest(url: url)
        
        let result = try await subject.perform(encoder: JSONEncoder(), request: urlRequest)
        #expect(!result.0.isEmpty)
    }

}

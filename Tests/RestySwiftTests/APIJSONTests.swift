//
//  APIJSONTests.swift
//  
//
//  Created by Chris Pflepsen on 2/28/23.
//

import XCTest
@testable import RestySwift

final class APIJSONTests: XCTestCase {

    let api = TestApi()
    let authProvider = MockAuthProvider()
    let versionProvider = MockVersionProvider()
    let sessionProvider = MockSessionProvider()
    var client: API!

    override func setUp() async throws {
        client = CustomAPI(cacheProvider: nil,
                           authProvider: authProvider,
                           versionProvider: versionProvider,
                           sessionProvider: sessionProvider)
    }

    func testJsonParsing() async throws {
        sessionProvider.results = [
            .unauthorized,
            .success(Dog.list)
        ]

        let dogs = try? await client.perform(request: DogRequest())
        XCTAssertNotNil(dogs)
        XCTAssert(authProvider.refreshTokenCalled == 1)
    }

    func testJsonParsingFailing() async {
        sessionProvider.results = [
            .unauthorized,
            .success(Dog.list)
        ]

        let failureMessage = "JSON parsing expected to fail"
        await XCTAssertThrowsErrorAsync(try await client.perform(request: CatRequest()),
                                   failureMessage) { error in
            guard case APIError.invalidJSON = error else {
                XCTFail(failureMessage)
                return
            }
        }
    }
}

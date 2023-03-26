//
//  APIJSONTests.swift
//  
//
//  Created by Chris Pflepsen on 2/28/23.
//

import XCTest
@testable import RestySwift

final class APIJSONTests: XCTestCase {

    let authProvider = MockAuthProvider()
    let versionProvider = MockVersionProvider()
    var api: CustomAPI!
    var sessionProvider: MockSessionProvider!

    override func setUp() async throws {
        api = CustomAPI(cacheProvider: nil,
                           authProvider: authProvider,
                           versionProvider: versionProvider)
        sessionProvider = MockSessionProvider(api: api)
    }

    func testJsonParsing() async throws {
        let connector: NetworkConnector = .queue([
            .unauthorized,
            .success(Dog.list)
        ])

        do {
            let dogs = try await api.perform(request: DogRequest(),
                                                networkConnector: connector)
            XCTAssertNotNil(dogs)
            XCTAssert(authProvider.refreshTokenCalled == 1)
        } catch let error {
            print(error)
        }
    }

    func testJsonParsingFailing() async {
        let connector: NetworkConnector = .queue([
            .unauthorized,
            .success(Dog.list)
        ])

        let failureMessage = "JSON parsing expected to fail"
        await XCTAssertThrowsErrorAsync(try await api.perform(request: CatRequest(),
                                                                 networkConnector: connector),
                                   failureMessage) { error in
            guard case APIError.invalidJSON = error else {
                XCTFail(failureMessage)
                return
            }
        }
    }
}

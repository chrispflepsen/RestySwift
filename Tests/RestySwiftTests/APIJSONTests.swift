//
//  APIJSONTests.swift
//  
//
//  Created by Chris Pflepsen on 2/28/23.
//

import XCTest
@testable import RestySwift

final class APIJSONTests: XCTestCase {

    var api = TestAPI()
    var sessionProvider: APIDataProvider!

    override func setUp() async throws {
        sessionProvider = MockDataProvider(api: api)
    }

    func testJsonParsing() async throws {
        let connector: NetworkConnector = .queue([
            .unauthorized,
            .success(Dog.list)
        ])

        do {
            let dogs = try await api.perform(request: DogRequest(),
                                                connector: connector)
            XCTAssertNotNil(dogs)
        } catch let error {
            print(error)
        }
    }

    func testJsonParsingFailing() async {
        let connector: NetworkConnector = .queue([
            .success(Dog.list)
        ])

        let failureMessage = "JSON parsing expected to fail"
        await XCTAssertThrowsErrorAsync(try await api.perform(request: CatRequest(),
                                                                 connector: connector),
                                   failureMessage) { error in
            guard case APIError.invalidJSON = error else {
                XCTFail(failureMessage)
                return
            }
        }
    }
}

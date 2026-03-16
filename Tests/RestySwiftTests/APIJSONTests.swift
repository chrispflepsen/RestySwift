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

    func testJsonParsing() async throws {
//        let q: Client = )

        do {
            let dogs = try await api.perform(
                request: DogRequest(),
                client: .queue([
                    .unauthorized,
                    .success(Dog.list)
                ])
            )
            XCTAssertNotNil(dogs)
        } catch let error {
            print(error)
        }
    }

    func testJsonParsingFailing() async {
        let connector: Client = .queue([
            .success(Dog.list)
        ])

        let failureMessage = "JSON parsing expected to fail"
        await XCTAssertThrowsErrorAsync(try await api.perform(request: CatRequest(),
                                                              client: connector),
                                   failureMessage) { error in
            guard case APIError.invalidJSON = error else {
                XCTFail(failureMessage)
                return
            }
        }
    }
}

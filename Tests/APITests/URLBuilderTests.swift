//
//  URLBuilderTests.swift
//  
//
//  Created by Chris Pflepsen on 2/28/23.
//

import XCTest
@testable import API

final class URLBuilderTests: XCTestCase {

    func testBuildFailure() async throws {
        let failureMessage = "Expect URL Build failure"
        XCTAssertThrowsError(try URLBuilder.build("https://example.test", path: "dogs", parameters: nil), failureMessage) { error in
            guard case APIError.unableToBuildRequest = error else {
                XCTFail(failureMessage)
                return
            }
        }
    }

    func testBuildBasic() async throws {
        let url = try URLBuilder.build("https://example.test", path: "/dogs", parameters: nil)
        XCTAssert(!url.absoluteString.isEmpty)
    }

    func testBuildHostOnly() async throws {
        let url = try URLBuilder.build("example.test", path: "/dogs", parameters: nil)
        XCTAssert(!url.absoluteString.isEmpty)
    }

    func testBuildBasicWWW() async throws {
        let url = try URLBuilder.build("https://www.example.test", path: "/dogs", parameters: nil)
        XCTAssert(!url.absoluteString.isEmpty)
    }

    func testBuildSingle() throws {
        let url = try URLBuilder.build("https://example.test", parameters: [
            "q": .single("query"),
            "filter": .single("name")
        ])

        guard let components = URLComponents(string: url.absoluteString) else {
            XCTFail("Expected to add query parameters to url")
            return
        }
        XCTAssertEqual(components.queryItems?.count, 2)
    }

    func testBuildArray() throws {
        let url = try URLBuilder.build("https://example.test", parameters: [
            "filter": .array([
                "name",
                "age",
                "title"
            ])
        ])

        guard let components = URLComponents(string: url.absoluteString) else {
            XCTFail("Expected to add query parameters to url")
            return
        }
        XCTAssertEqual(components.queryItems?.count, 3)
    }

    func testBuildMixed() throws {
        let url = try URLBuilder.build("https://example.test", parameters: [
            "filter": .array([
                "name",
                "age",
                "title"
            ]),
            "q": .single("search_query")
        ])

        guard let components = URLComponents(string: url.absoluteString) else {
            XCTFail("Expected to add query parameters to url")
            return
        }
        XCTAssertEqual(components.queryItems?.count, 4)
    }

}

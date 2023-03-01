//
//  HTTPStatusCodeTests.swift
//  
//
//  Created by Chris Pflepsen on 3/1/23.
//

import XCTest
@testable import API

final class HTTPStatusCodeTests: XCTestCase {

    func testStatusCodes() throws {
        HTTPStatus.allCases.forEach {
            let statusCode = $0.statusCode
            let status = HTTPStatus(statusCode: statusCode)
            XCTAssertEqual(status, $0)

            let expectedSuccess = statusCode >= 200 && statusCode < 300
            XCTAssertEqual(expectedSuccess, status.isSuccess)
        }
    }

}

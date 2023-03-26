//
//  SafeIndexTests.swift
//  
//
//  Created by Chris Pflepsen on 3/25/23.
//

import XCTest
@testable import RestySwift

//final class SafeIndexTests: XCTestCase {
//
//    let array = [1,2,3]
//
//    func testNegative() throws {
//        @SafeIndex(array) var index = -1
//        XCTAssert(index == 0)
//    }
//
//    func testZero() throws {
//        @SafeIndex(array) var index = 0
//        XCTAssert(index == 0)
//    }
//
//    func testValid() throws {
//        @SafeIndex(array) var index = 1
//        XCTAssert(index == 1)
//    }
//
//    func testLast() throws {
//        @SafeIndex(array) var index = 2
//        XCTAssert(index == 2)
//    }
//
//    func testOver() throws {
//        @SafeIndex(array) var index = 3
//        XCTAssert(index == 2)
//    }
//
//    func testWayOver() throws {
//        for value in (3...100) {
//            @SafeIndex(array) var index = value
//            XCTAssert(index == 2)
//        }
//    }
//
//    func testUpdate() throws {
//        @SafeIndex(array) var index = -1
//        XCTAssert(index == 0)
//        index = 0
//        XCTAssert(index == 0)
//        index = 1
//        XCTAssert(index == 1)
//        index = 2
//        XCTAssert(index == 2)
//        index = 3
//        XCTAssert(index == 2)
//        index = 4
//        XCTAssert(index == 2)
//        index = -1
//        XCTAssert(index == 0)
//    }
//}

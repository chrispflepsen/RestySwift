//
//  PathComponentTests.swift
//  
//
//  Created by Chris Pflepsen on 4/5/23.
//

import XCTest
@testable import RestySwift

final class PathComponentTests: XCTestCase {

    func testInitSlash() throws {
        let path = "/dog"
        XCTAssert(PathComponent(path).path == path)
    }

    func testInitNoSlash() throws {
        let path = "dog"
        XCTAssert(PathComponent(path).path == "/\(path)")
    }

    func testConcatLeadingNil() throws {
        let pathComponent = PathComponent(nil) + PathComponent("dog")
        XCTAssert(pathComponent.path == "/dog")
    }

    func testConcatTrailingNil() throws {
        let pathComponent = PathComponent("dog") + PathComponent(nil)
        XCTAssert(pathComponent.path == "/dog")
    }

    func testConcatMultiple() throws {
        let component = PathComponent(nil) + PathComponent("Dog") + PathComponent(nil) + PathComponent("1") + PathComponent("edit")
        XCTAssert(component.path == "/Dog/1/edit")
    }

}

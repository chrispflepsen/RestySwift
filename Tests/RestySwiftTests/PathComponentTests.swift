//
//  PathComponentTests.swift
//  
//
//  Created by Chris Pflepsen on 4/5/23.
//

import Testing
@testable import RestySwift

struct PathComponentTests {
    @Test func initSlash() throws {
        let path = "/dog"
        #expect(PathComponent(path).path == path)
    }

    @Test func initNoSlash() throws {
        let path = "dog"
        #expect(PathComponent(path).path == "/\(path)")
    }

    @Test func tconcatLeadingNil() throws {
        let pathComponent = PathComponent(nil) + PathComponent("dog")
        #expect(pathComponent.path == "/dog")
    }

    @Test func concatTrailingNil() throws {
        let pathComponent = PathComponent("dog") + PathComponent(nil)
        #expect(pathComponent.path == "/dog")
    }

    @Test func concatMultiple() throws {
        let component = PathComponent(nil) + PathComponent("Dog") + PathComponent(nil) + PathComponent("1") + PathComponent("edit")
        #expect(component.path == "/Dog/1/edit")
    }
}

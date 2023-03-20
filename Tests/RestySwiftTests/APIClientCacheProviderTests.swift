//
//  APIClientCacheProviderTests.swift
//  
//
//  Created by Chris Pflepsen on 3/1/23.
//

import XCTest
@testable import RestySwift

final class APIClientCacheProviderTests: XCTestCase {

    let api = TestApi()
    let versionProvider = MockVersionProvider()
    let sessionProvider = MockSessionProvider()
    let cacheProvider = MockCacheProvider()
    var client: API!

    override func setUp() async throws {
        client = CustomAPI(cacheProvider: cacheProvider,
                           authProvider: nil,
                           versionProvider: versionProvider,
                           sessionProvider: sessionProvider)
    }

    func testNoCache() async throws {
        let emptyCache = MockEmptyCacheProvider()
        client.cacheProvider = emptyCache
        sessionProvider.results = [
            .success(Dog.list)
        ]

        let dog = try await client.perform(request: DogRequest())
        XCTAssertNotNil(dog)
        XCTAssert(emptyCache.readObjects == 1)
        XCTAssert(sessionProvider.dataForRequestCalled == 1)
    }

    func testReadFromCache() async throws {
        sessionProvider.results = [
            .success(Dog.list)
        ]

        let dog = try await client.perform(request: DogRequest())
        XCTAssertNotNil(dog)
        XCTAssert(cacheProvider.readObjects == 1)
        XCTAssert(sessionProvider.dataForRequestCalled == 0)
    }

}

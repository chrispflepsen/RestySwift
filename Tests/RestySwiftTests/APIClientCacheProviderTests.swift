//
//  APIClientCacheProviderTests.swift
//  
//
//  Created by Chris Pflepsen on 3/1/23.
//

import XCTest
@testable import RestySwift

final class APIClientCacheProviderTests: XCTestCase {

    let versionProvider = MockVersionProvider()
    let cacheProvider = MockCacheProvider()
    var api: API!
    var sessionProvider: MockSessionProvider!

    override func setUp() async throws {
        api = CustomAPI(cacheProvider: cacheProvider,
                           authProvider: nil,
                           versionProvider: versionProvider)
        sessionProvider = MockSessionProvider(api: api)
    }

    func testNoCache() async throws {
        let emptyCache = MockEmptyCacheProvider()
        api.cacheProvider = emptyCache
        sessionProvider.connector = .single(.success(Dog.list))

        let dog = try await api.perform(request: DogRequest(),
                                        sessionProvider: sessionProvider)
        XCTAssertNotNil(dog)
        XCTAssert(emptyCache.readObjects == 1)
        XCTAssert(sessionProvider.dataForRequestCalled == 1)
    }

    func testReadFromCache() async throws {
        sessionProvider.connector = .single(.success(Dog.list))

        let dog = try await api.perform(request: DogRequest(),
                                        sessionProvider: sessionProvider)
        XCTAssertNotNil(dog)
        XCTAssert(cacheProvider.readObjects == 1)
        XCTAssert(sessionProvider.dataForRequestCalled == 0)
    }

}

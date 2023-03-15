//
//  APIClientAuthProviderTests.swift
//  
//
//  Created by Chris Pflepsen on 2/28/23.
//

import XCTest
@testable import RestySwift

final class APIClientAuthProviderTests: XCTestCase {

    let api = TestApi()
    let versionProvider = MockVersionProvider()
    let sessionProvider = MockSessionProvider()
    var client: APIClient!

    override func setUp() async throws {
        client = APIClient(api: api,
                           cacheProvider: nil,
                           authProvider: nil,
                           versionProvider: versionProvider,
                           sessionProvider: sessionProvider)
    }

    func testFailingAuthProvider() async throws {
        let failingProvider = MockFailingAuthProvider()
        client.authProvider = failingProvider
        sessionProvider.results = [
            .unauthorized,
            .success(Dog.list)
        ]

        let expectation = "Expect unauthorized error"
        await XCTAssertThrowsErrorAsync(try await client.perform(request: DogRequest()),
                                        expectation) { error in
            switch error {
            case APIError.invalidHTTPStatus(let status):
                XCTAssertEqual(status, .unauthorized)
                XCTAssert(failingProvider.refreshTokenCalled == 1)
                XCTAssert(failingProvider.injectCredentialsCalled == 1)
            default:
                XCTFail(expectation)
            }
        }
    }

    func testSuccessAuthProvider() async throws {
        let provider = MockAuthProvider()
        client.authProvider = provider
        sessionProvider.results = [
            .unauthorized,
            .success(Dog.list)
        ]

        let dogs = try? await client.perform(request: DogRequest())
        XCTAssertNotNil(dogs)
        XCTAssert(provider.refreshTokenCalled == 1)
        XCTAssert(provider.injectCredentialsCalled == 2)
    }

    func testNoAuthProvider() async throws {
        client.authProvider = nil
        sessionProvider.results = [
            .unauthorized,
            .success(Dog.list)
        ]

        let expectation = "Expected failure due to unauthorized response and no auth provider"
        await XCTAssertThrowsErrorAsync(try await client.perform(request: DogRequest()),
                                        expectation) { error in
            switch error {
            case APIError.invalidHTTPStatus(let status):
                XCTAssertEqual(status, .unauthorized)
            default:
                XCTFail(expectation)
            }
        }
    }

    func testrefreshAuthenticationFailure() async throws {
        let authProvider = MockAuthProvider()
        client.authProvider = authProvider
        sessionProvider.results = [
            .unauthorized,
            .unauthorized
        ]

        let dogs = try? await client.perform(request: DogRequest())
        XCTAssertNil(dogs)
        XCTAssert(authProvider.refreshTokenCalled == 1)
        XCTAssert(sessionProvider.dataForRequestCalled == 2)
    }

}

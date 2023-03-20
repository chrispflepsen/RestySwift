//
//  APIClientAuthProviderTests.swift
//  
//
//  Created by Chris Pflepsen on 2/28/23.
//

import XCTest
@testable import RestySwift

struct BaseAPI: API {
    var baseUrl: String = "test.com"
    var headers = [String : String]()
    var encoder: JSONEncoder = JSONEncoder()
    var decoder: JSONDecoder = JSONDecoder()
}

struct CustomAPI: API {
    var baseUrl: String
    var headers: [String : String]
    var encoder: JSONEncoder
    var decoder: JSONDecoder

    var cacheProvider: CacheProvider?
    var authProvider: AuthenticationProvider?
    var versionProvider: VersionProvider?
    var sessionProvider: SessionProvider

    init(baseAPI: BaseAPI = BaseAPI(),
         cacheProvider: CacheProvider?,
         authProvider: AuthenticationProvider?,
         versionProvider: VersionProvider?,
         sessionProvider: SessionProvider) {
        self.baseUrl = baseAPI.baseUrl
        self.headers = baseAPI.headers
        self.encoder = baseAPI.encoder
        self.decoder = baseAPI.decoder

        self.cacheProvider = cacheProvider
        self.authProvider = authProvider
        self.versionProvider = versionProvider
        self.sessionProvider = sessionProvider
    }


}

final class APIClientAuthProviderTests: XCTestCase {

    let api = TestApi()
    let versionProvider = MockVersionProvider()
    let sessionProvider = MockSessionProvider()
    var client: API!

    override func setUp() async throws {
        client = CustomAPI(cacheProvider: nil,
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

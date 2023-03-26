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

    init(baseAPI: BaseAPI = BaseAPI(),
         cacheProvider: CacheProvider?,
         authProvider: AuthenticationProvider?,
         versionProvider: VersionProvider?) {
        self.baseUrl = baseAPI.baseUrl
        self.headers = baseAPI.headers
        self.encoder = baseAPI.encoder
        self.decoder = baseAPI.decoder

        self.cacheProvider = cacheProvider
        self.authProvider = authProvider
        self.versionProvider = versionProvider
    }
}

final class APIClientAuthProviderTests: XCTestCase {

    let versionProvider = MockVersionProvider()
    var sessionProvider: MockSessionProvider!
    var api: API!

    override func setUp() async throws {
        api = CustomAPI(cacheProvider: nil,
                           authProvider: nil,
                           versionProvider: versionProvider)
        sessionProvider = MockSessionProvider(api: api)
    }

    func testFailingAuthProvider() async throws {
        let failingProvider = MockFailingAuthProvider()
        api.authProvider = failingProvider

        let connector: NetworkConnector = .queue([
            .unauthorized,
            .success(Dog.list)
        ])

        let expectation = "Expect unauthorized error"
        await XCTAssertThrowsErrorAsync(try await api.perform(request: DogRequest(),
                                                                 networkConnector: connector),
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
        api.authProvider = provider
        sessionProvider.connector = .queue([
            .unauthorized,
            .success(Dog.list)
        ])

        let dogs = try? await api.perform(request: DogRequest(),
                                          sessionProvider: sessionProvider)
        XCTAssertNotNil(dogs)
        XCTAssert(provider.refreshTokenCalled == 1)
        XCTAssert(provider.injectCredentialsCalled == 2)
    }

    func testNoAuthProvider() async throws {
        api.authProvider = nil
        sessionProvider.connector = .queue([
            .unauthorized,
            .success(Dog.list)
        ])

        let expectation = "Expected failure due to unauthorized response and no auth provider"
        await XCTAssertThrowsErrorAsync(try await api.perform(request: DogRequest(),
                                                              sessionProvider: sessionProvider),
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
        api.authProvider = authProvider
        sessionProvider.connector = .queue([
            .unauthorized,
            .unauthorized
        ])

        let dogs = try? await api.perform(request: DogRequest(),
                                          sessionProvider: sessionProvider)
        XCTAssertNil(dogs)
        XCTAssert(authProvider.refreshTokenCalled == 1)
        XCTAssert(sessionProvider.dataForRequestCalled == 2)
    }

}

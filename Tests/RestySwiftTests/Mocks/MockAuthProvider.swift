//
//  TestApi.swift
//  
//
//  Created by Chris Pflepsen on 2/8/23.
//

import Foundation
@testable import RestySwift

class MockAuthProvider: AuthenticationProvider {
    var injectCredentialsCalled = 0
    var refreshTokenCalled = 0
    var supportsRefresh: Bool { true }

    func reset() {
        injectCredentialsCalled = 0
        refreshTokenCalled = 0
    }

    func injectCredentials(forRequest: some APIRequest, urlRequest: inout URLRequest) {
        injectCredentialsCalled += 1
    }

    func refreshAuthentication() async throws -> AuthenticationRefresh {
        refreshTokenCalled += 1
        return .success
    }
}

class MockFailingAuthProvider: MockAuthProvider {
    override func refreshAuthentication() async throws -> AuthenticationRefresh {
        refreshTokenCalled += 1
        return .failed
    }
}

class MockVersionProvider: VersionProvider {
    func versionString(forRequest: some APIRequest) -> String { "v0" }
}

struct TestApi: API {
    var baseUrl: String = "www.api.test"
    var headers: [String : String] = [:]
    var encoder: JSONEncoder = JSONEncoder()
    var decoder: JSONDecoder = JSONDecoder()
}

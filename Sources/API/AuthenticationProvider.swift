//
//  AuthenticationProvider.swift
//  API
//
//  Created by Chris Pflepsen on 11/2/22.
//

import Foundation

public protocol AuthenticationUser {
    var id: String? { get }
}

public protocol AuthenticationProvider {
    func injectCredentials(request: inout URLRequest)
    func refreshToken() async throws -> AuthenticationStatus
}

public protocol VersionProvider {
    func versionString(forRequest: some APIRequest) -> String
}

public enum AuthenticationStatus {
    case loggedIn
    case loggedOut
}

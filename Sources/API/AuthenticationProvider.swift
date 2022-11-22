//
//  AuthenticationProvider.swift
//  API
//
//  Created by Chris Pflepsen on 11/2/22.
//

import Foundation

public protocol User {
    var id: String { get }
}

public protocol AuthenticationProvider {
    var isAuthenticated: Bool { get }
    var user: User? { get }
    var status: AuthenticationStatus { get }
    
    func injectCredentials(request: URLRequest)
    func refreshToken() async throws -> AuthenticationStatus
}

public protocol VersionProvider {
    func versionString(forRequest: some APIRequest) -> String
}

public enum AuthenticationStatus {
    case loggedIn
    case loggedOut
}

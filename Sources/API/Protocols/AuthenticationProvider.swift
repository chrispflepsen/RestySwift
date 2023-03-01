//
//  AuthenticationProvider.swift
//  API
//
//  Created by Chris Pflepsen on 11/2/22.
//

import Foundation

//public protocol AuthenticationUser {
//    var id: String? { get }
//}

public protocol AuthenticationProvider {
    var supportsRefresh: Bool { get }
    func injectCredentials(forRequest: some APIRequest, urlRequest: inout URLRequest)
    func refreshAuthentication() async throws -> AuthenticationStatus
}

public protocol VersionProvider {
    func versionString(forRequest: some APIRequest) -> String
}

public enum AuthenticationStatus: String {
    case loggedIn
    case loggedOut
}

//
//  AuthenticationProvider.swift
//  API
//
//  Created by Chris Pflepsen on 11/2/22.
//

import Foundation

public protocol AuthenticationProvider {
    var supportsRefresh: Bool { get }
    func refreshAuthentication() async throws -> AuthenticationRefresh
    func injectCredentials(forRequest: some APIRequest, urlRequest: inout URLRequest)
}

public enum AuthenticationRefresh: String {
    case success
    case failed
}

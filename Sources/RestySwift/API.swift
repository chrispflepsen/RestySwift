//
//  API.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

public protocol API {
    var baseUrl: String { get }
    var headers: [String: String] { get }
    var encoder: JSONEncoder { get }
    var decoder: JSONDecoder { get }
    var cacheProvider: CacheProvider? { get set }
    var authProvider: AuthenticationProvider? { get set }
    var versionProvider: VersionProvider? { get set }
    var sessionProvider: SessionProvider { get set }
}

public extension API {
    var cacheProvider: CacheProvider? {
        get { nil }
        set { }
    }
    var authProvider: AuthenticationProvider? {
        get { nil }
        set { }
    }
    var versionProvider: VersionProvider? {
        get { nil }
        set { }
    }
    var sessionProvider: SessionProvider {
        get { URLSession.shared }
        set { }
    }
}

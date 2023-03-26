//
//  API.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

struct Moped {
    let name: String
}

// All requests
public protocol API {
    var baseUrl: String { get }
    var headers: [String: String] { get }
    var encoder: JSONEncoder { get }
    var decoder: JSONDecoder { get }

    // Optional
    var cacheProvider: CacheProvider? { get set }
    var authProvider: AuthenticationProvider? { get set }
    var versionProvider: VersionProvider? { get set }
}

public extension API {
    var headers: [String: String] { [String: String]() }
    var encoder: JSONEncoder { JSONEncoder() }
    var decoder: JSONDecoder { JSONDecoder() }

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
}

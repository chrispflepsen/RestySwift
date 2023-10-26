//
//  API.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

// All requests
public protocol API {
    var baseUrl: String { get }

    // Optional
    var encoder: JSONEncoder { get }
    var decoder: JSONDecoder { get }
    var middlewares: [Middleware]? { get }
    var defaults: Defaults? { get }
    var options: Options { get }
}

public extension API {
    var encoder: JSONEncoder { JSONEncoder() }
    var decoder: JSONDecoder { JSONDecoder() }
    var middlewares: [Middleware]? { nil }
    var defaults: Defaults? { nil }
    var options: Options { Options() }
}

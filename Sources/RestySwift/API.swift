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
    var headers: [String: String] { get }
    var encoder: JSONEncoder { get }
    var decoder: JSONDecoder { get }
    var middleware: [Middleware] { get }
}

public extension API {
    var headers: [String: String] { [String: String]() }
    var encoder: JSONEncoder { JSONEncoder() }
    var decoder: JSONDecoder { JSONDecoder() }
}

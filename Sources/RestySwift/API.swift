//
//  API.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

/// The `API` protocol defines the structure of an API in the RestySwift package. Defining everything needed to connect to the REST API.
///
/// An `API` must specify the baseUrl
///
/// - Properties:
///   - baseUrl: The base URL for the API.
///   - encoder: An optional JSON encoder used for encoding request parameters. Defaults to `JSONEncoder()`.
///   - decoder: An optional JSON decoder used for decoding response data. Defaults to `JSONDecoder()`.
///   - middlewares: An optional array of middlewares that can be applied to the API requests. Defaults to `nil`.
///   - defaults: An optional set of default settings and configurations for the API. Defaults to `nil`.
///
public protocol API {
    /// The base URL for the API.
    var baseUrl: String { get }

    // MARK: - Optional

    /// An optional JSON encoder used for encoding request parameters.
    var encoder: JSONEncoder { get }

    /// An optional JSON decoder used for decoding response data.
    var decoder: JSONDecoder { get }

    /// An optional array of middlewares that can be applied to the API requests.
    var middlewares: [Middleware]? { get }

    /// An optional set of default settings for the API.
    var defaults: RequestDefaults? { get }
}

public extension API {
    var encoder: JSONEncoder { JSONEncoder() }
    var decoder: JSONDecoder { JSONDecoder() }
    var middlewares: [Middleware]? { nil }
    var defaults: RequestDefaults? { nil }
}

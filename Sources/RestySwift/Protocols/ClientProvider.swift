//
//  ClientProvider.swift
//  RestySwift
//
//  Created by Chris Pflepsen on 3/14/26.
//

import Foundation

/// A protocol for providing a `HTTPClient`.
public protocol ClientProvider {
    /// The HTTP client for the connection.
    var client: HTTPClient { get }
}

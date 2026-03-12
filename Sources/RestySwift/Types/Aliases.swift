//
//  Aliases.swift
//  RestySwift
//
//  Created by Chris Pflepsen on 3/14/26.
//

import Foundation

/// HTTP header representation `[String: String]`
public typealias Headers = [String: String]

/// HTTP query parameters representation `[String: QueryParameter]`
public typealias Parameters = [String: QueryParameter]

/// Representation of a single field in a url query
public enum QueryParameter: Equatable {
    case single(String)
    case array([String])
}

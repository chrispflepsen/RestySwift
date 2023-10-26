//
//  Defaults.swift
//  
//
//  Created by Chris Pflepsen on 10/25/23.
//

import Foundation

/// Default values that will be applied to all requests performed against the API
public protocol Defaults {
    var parameters: Parameters? { get }
    var headers: Headers? { get }
}

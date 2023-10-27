//
//  Defaults.swift
//  
//
//  Created by Chris Pflepsen on 10/25/23.
//

import Foundation

/// Default values (parameters and headers) that will be applied to all requests performed on the API
public protocol RequestDefaults {
    var parameters: Parameters? { get }
    var headers: Headers? { get }
}

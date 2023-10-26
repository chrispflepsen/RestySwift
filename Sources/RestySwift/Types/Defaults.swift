//
//  Defaults.swift
//  
//
//  Created by Chris Pflepsen on 10/25/23.
//

import Foundation

public protocol Defaults {
    var parameters: Parameters? { get }
    var headers: Headers? { get }
}

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
}

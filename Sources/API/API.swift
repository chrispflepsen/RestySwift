//
//  API.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

protocol API {
    var baseUrl: URL { get }
    var headers: [String: String] { get }
    var encoder: JSONEncoder { get }
    var decoder: JSONDecoder { get }
}

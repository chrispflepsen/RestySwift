//
//  APIRequest.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

public protocol APIRequest {
    associatedtype Body: Encodable
    associatedtype Response: Decodable
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: String]? { get }
    var body: Body { get }
}

public extension APIRequest {
    var parameters: [String: String]? { nil }
}

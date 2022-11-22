//
//  APIRequest.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

public protocol APIRequest {
    associatedtype T: Encodable
    associatedtype Response: Decodable
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: String]? { get }
    var body: T { get }
}

extension APIRequest {
    var httpMethod: HTTPMethod { .GET }
    var parameters: [String: String]? { nil }
    var body: EmptyBody? { EmptyBody() }
}

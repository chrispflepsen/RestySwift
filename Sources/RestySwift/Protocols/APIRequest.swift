//
//  APIRequest.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

public enum QueryParameter {
    case single(String)
    case array([String])
}

public protocol APIRequest {
    associatedtype Body: Encodable
    associatedtype Response: Decodable
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: QueryParameter]? { get }
    var headers: [String: String]? { get }
    var body: Body? { get }
}

public extension APIRequest {
    var parameters: [String: QueryParameter]? { nil }
    var headers: [String: String]? { nil }
}

public protocol BindingRequest: APIRequest {
    var api: API { get }
}




public typealias PagableObject = Codable & Identifiable

public protocol PagedBindingRequest: BindingRequest where Response: Collection, Response.Element: PagableObject {
    var pageSize: Int { get }
    var startPage: Int { get }
}

extension PagedBindingRequest {
    var startPage: Int { 1 }
}

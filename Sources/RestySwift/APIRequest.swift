//
//  APIRequest.swift
//  
//
//  Created by Chris Pflepsen on 10/26/23.
//

import Foundation

/// The `APIRequest` protocol defines the structure of a request in the RestySwift
///
/// An `APIRequest` must specify the HTTP method, path, parameters, headers, and the response type.
///
/// - Parameters:
///   - Body: The type that represents the request body. It is `Encodable` and defaults to `EmptyBody`.
///   - Response: The type that represents the expected response, and it is `Decodable`.
///
/// - Properties:
///   - path: The path for the API request, specifying the endpoint to which the request will be sent.
///   - httpMethod: The HTTP method for the API request. Defaults to `.GET`.
///   - parameters: Optional parameters to include in the request. Defaults to `nil`.
///   - headers: Optional headers to include in the request. Defaults to `nil`.
///   - body: The request body, conforming to the `Body` type. Defaults to `nil`.
///
/// The `APIRequest` protocol allows for the creation of request objects that can be used to make HTTP
/// requests in RestySwift. Implementing types must provide appropriate values for the properties
/// to define the specific API request.
///
public protocol APIRequest {
    associatedtype Body: Encodable = EmptyBody
    associatedtype Response: Decodable
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var headers: Headers? { get }
    var body: Body { get }
}

public extension APIRequest {
    var httpMethod: HTTPMethod { .GET }
    var parameters: Parameters? { nil }
    var headers: Headers? { nil }
    var body: EmptyBody? { nil }
}

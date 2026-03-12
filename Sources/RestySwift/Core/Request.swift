//
//  Request.swift
//  
//
//  Created by Chris Pflepsen on 10/26/23.
//

import Foundation

/// The `Request` protocol defines the structure of a request in the RestySwift.
///
/// An `Request` must specify the HTTP method, path, parameters, headers, and the response type.
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
/// The `Request` protocol allows for the creation of request objects that can be used to make HTTP
/// requests in RestySwift. Implementing types must provide appropriate values for the properties
/// to define the specific API request.
///
public protocol Request {
    /// The type of the body of the request.
    associatedtype Body: Encodable = EmptyBody
    
    /// The type of the response of the request.
    associatedtype Response: Decodable
    
    /// The `HTTPMethod` of the request: `.GET`, `.POST`, `.DELETE`, etc.
    var httpMethod: HTTPMethod { get }
    
    /// The path of the request.
    var path: String { get }
    
    /// The optional `Parameters` to be appended to the url for the request.
    var parameters: Parameters? { get }
    
    /// The optional `Headers`to be added to the request.
    var headers: Headers? { get }
    
    /// The body of the request.
    var body: Body { get }
}

/// Default implementation of a `Request`.
///
/// Defaults to a `.GET` request with no parameters or headers.
///
public extension Request {
    var httpMethod: HTTPMethod { .GET }
    var parameters: Parameters? { nil }
    var headers: Headers? { nil }
    var body: EmptyBody? { nil }
}

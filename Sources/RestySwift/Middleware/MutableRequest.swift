//
//  MutableRequest.swift
//  RestySwift
//
//  Created by Chris Pflepsen on 3/13/26.
//

import Foundation

/// An editable representation of a request used by middleware.
public class MutableRequest<T: Request>: Request {
    public typealias Response = T.Response
    
    /// The `HTTPMethod`
    public var httpMethod: HTTPMethod
    
    /// The path for the request.
    ///
    /// Should always begin with "/"
    public var path: String
    
    /// The parameters for the request.
    public var parameters: Parameters? = nil
    
    /// The headers for the request.
    public var headers: Headers? = nil
    
    /// The body of the request.
    public var body: T.Body
 
    init(
        httpMethod: HTTPMethod,
        path: String,
        parameters: Parameters? = nil,
        headers: Headers? = nil,
        body: T.Body
    ) {
        self.httpMethod = httpMethod
        self.path = path
        self.parameters = parameters
        self.headers = headers
        self.body = body
    }
    
    init(
        request: T
    ) {
        self.httpMethod = request.httpMethod
        self.path = request.path
        self.parameters = request.parameters
        self.headers = request.headers
        self.body = request.body
    }
}

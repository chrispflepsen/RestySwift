//
//  OrderedMiddleware.swift
//
//
//  Created by Chris Pflepsen on 10/25/23.
//

import Foundation
import RestySwift
import OSLog

protocol OrderDelegate: AnyObject {
    func requestRecieved(_ order: Int)
    func responseRecieved(_ order: Int)
}

struct OrderedMiddleware: Middleware {
    let order: Int
    weak var delegate: OrderDelegate!

    func intercept<T: APIRequest>(_ request: T, next: (T) async throws -> APIResponse) async throws -> APIResponse {
        delegate.requestRecieved(order)
        let response = try await next(request)
        delegate.responseRecieved(order)
        return response
    }
}

//struct LoggingMiddleware: Middleware {
//
//
//
//    func intercept<T: APIRequest>(_ request: T,
//                      next: (T) async throws -> (Data, URLResponse)) async throws -> (Data, URLResponse) {
//        let logger = Logger(subsystem: "RestySwift",
//                            category: "Middleware")
//        logger.info("sending request")
//
//
//
//        let (data, response) = try await next(request)
//
//
//
//        return (data, response)
//    }
//    
//
//}

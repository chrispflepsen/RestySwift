//
//  ThrowingMiddleware.swift
//  RestySwift
//
//  Created by Chris Pflepsen on 3/12/26.
//

import Foundation

@testable import RestySwift

struct ThrowingMiddleware: Middleware {
    func interceptRequest<T>(_ request: T) async throws -> T where T : Request {
        throw MiddlewareError.generic
    }
    
    func interceptResponse(_ response: Response) async throws -> Response {
        throw MiddlewareError.generic
    }
}

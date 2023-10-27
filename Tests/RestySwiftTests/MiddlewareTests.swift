//
//  MiddlewareTests.swift
//  
//
//  Created by Chris Pflepsen on 10/25/23.
//

import XCTest
@testable import RestySwift

struct DummyRequest: APIRequest {
    typealias Response = EmptyResponse
    var path: String { "/dummy"}
}

class TestOrderDelegate: OrderDelegate {

    private(set) var requestOrder = [Int]()
    private(set) var responseOrder = [Int]()


    func requestRecieved(_ order: Int) {
        requestOrder.append(order)
    }
    
    func responseRecieved(_ order: Int) {
        responseOrder.append(order)
    }
}

struct ErrorMiddleware: Middleware {
    let error: Error
    func intercept<T>(_ request: T, next: (T) async throws -> APIResponse) async throws -> APIResponse {
        throw error
    }
}

final class MiddlewareTests: XCTestCase {

    var api = RestyAPI()

    func testMiddlewareOrder() async throws {
        let delegate = TestOrderDelegate()
        api.middlewares = (0..<10).map { OrderedMiddleware(order: $0,
                                                           delegate: delegate) }

        _ = try await api.perform(request: DummyRequest(),
                                           connector: .single(.success(EmptyResponse())))
        for i in 1..<delegate.requestOrder.count {
            let currentElement = delegate.requestOrder[i]
            let prevElement = delegate.requestOrder[i - 1]
            XCTAssert(prevElement <= currentElement, "Middleware requests were not called in correct order")
        }

        for i in 1..<delegate.responseOrder.count {
            let currentElement = delegate.responseOrder[i]
            let prevElement = delegate.responseOrder[i - 1]
            XCTAssert(prevElement >= currentElement, "Middleware responses were not called in correct order")
        }
    }
}

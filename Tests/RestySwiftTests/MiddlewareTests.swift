//
//  MiddlewareTest.swift
//  RestySwift
//
//  Created by Chris Pflepsen on 3/12/26.
//

import Foundation
import Testing

@testable import RestySwift

struct PathAppendingMiddleware: Middleware {
    func interceptRequest<T: Request>(_ request: MutableRequest<T>) async throws -> MutableRequest<T> {
        request.path += "/list"
        return request
    }
    
    func interceptResponse(_ response: Response) async throws -> Response {
        response
    }
}

struct PathAppendingActiongMiddleware: Middleware {
    func interceptRequest<T: Request>(_ request: MutableRequest<T>) async throws -> MutableRequest<T> {
        request.path += "/action"
        return request
    }
    
    func interceptResponse(_ response: Response) async throws -> Response {
        response
    }
}

class MiddlewareTest {
    
    var api = RestyAPI()

    @Test func testModifyRequest() async throws {
            do {
                api.middleware = [
                    PathAppendingMiddleware(),
                    PathAppendingActiongMiddleware()
                ]
                
                let mock = MockClient(client: .single(.success([Dog.indy])))

                let result = try await api.perform(
                    request: DogRequest(),
                    client: .custom(mock)
                )
                #expect(result == [Dog.indy])
                #expect(mock.requests.first?.url == URL(string: "http://site.test/dog/list/action")!)
            } catch {}
    }

}

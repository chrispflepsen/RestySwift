//
//  MiddlewareTests.swift
//  
//
//  Created by Chris Pflepsen on 10/25/23.
//

import XCTest
@testable import RestySwift

struct DummyRequest: Request {
    typealias Response = EmptyResponse
    var path: String { "/dummy" }
}

struct FirstDogMiddleware: Middleware {
    func interceptRequest<T>(_ request: T) async throws -> T where T : Request {
        return request
    }
    
    func interceptResponse(_ response: Response) async throws -> Response {
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        var dogs = try decoder.decode([Dog].self, from: response.data)
        dogs.append(Dog.tazo)
        response.data = try encoder.encode(dogs)
        return response
    }
}

struct SecondDogMiddleware: Middleware {
    func interceptRequest<T>(_ request: T) async throws -> T where T : Request {
        return request
    }
    
    func interceptResponse(_ response: Response) async throws -> Response {
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        var dogs = try decoder.decode([Dog].self, from: response.data)
        dogs.append(Dog.indy)
        response.data = try encoder.encode(dogs)
        return response
    }
}

struct ModifyiedResponseMiddleware: Middleware {
    func interceptRequest<T>(_ request: T) async throws -> T where T : RestySwift.Request {
        return request
    }
    
    func interceptResponse(_ response: RestySwift.Response) async throws -> RestySwift.Response {
        response.headers = [
            "content/type": "dogs"
        ]
        response.statusCode = .noContent
        let encoder = JSONEncoder()
        response.data = try encoder.encode([Dog.indy])
        return response
    }
}

struct UnauthorizedResponseMiddleware: Middleware {
    func interceptRequest<T>(_ request: T) async throws -> T where T : RestySwift.Request {
        return request
    }
    
    func interceptResponse(_ response: RestySwift.Response) async throws -> RestySwift.Response {
        response.headers = [
            "content/type": "dogs"
        ]
        response.statusCode = .unauthorized
        return response
    }
}

final class LegacyMiddlewareTests: XCTestCase {

    var api = RestyAPI()

    func testThrowingMiddleware() async throws {
        api.middleware = [
            ThrowingMiddleware()
        ]

        do {
            _ = try await api.perform(request: DummyRequest(),
                                      client: .single(.success(EmptyResponse())))
            XCTFail("Should throw")
        } catch {}
    }
    
    func testMiddleWareOrder() async throws {
        api.middleware = [
            FirstDogMiddleware(),
            SecondDogMiddleware(),
        ]

        let response = try await api.perform(
            request: DogRequest(),
            client: .single(.success([Dog.nitro]))
        )
        
        XCTAssertEqual(response, [
            Dog.nitro,
            Dog.indy,
            Dog.tazo,
        ])
    }
    
    func testModifiedResponse() async throws {
        api.middleware = [
            ModifyiedResponseMiddleware()
        ]
        
        let response = try await api.perform(
            request: DogRequest(),
            client: .single(.success([Dog.tazo]))
        )
        
        XCTAssertEqual(response, [Dog.indy])
    }
    
    func testModifiedStatusCodeResponse() async throws {
        api.middleware = [
            UnauthorizedResponseMiddleware()
        ]
        
        do {
            _ = try await api.perform(
                request: DogRequest(),
                client: .single(.success([Dog.tazo]))
            )
            XCTFail("Should throw")
        } catch {}
    }
}

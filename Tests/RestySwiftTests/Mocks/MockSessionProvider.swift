//
//  MockSessionProvider.swift
//  
//
//  Created by Chris Pflepsen on 2/8/23.
//

import Foundation
@testable import RestySwift

enum SessionResult {
    case success(Encodable)
    case noContent
    case unauthorized
    case forbidden
    case error(Error)
}

class MockSessionProvider {

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    var results = [SessionResult]()

    var dataForRequestCalled = 0
    var uploadForRequestCalled = 0
    var callCount = 0

    func reset() {
        dataForRequestCalled = 0
        uploadForRequestCalled = 0
        callCount = 0
    }

    func next() -> SessionResult {
        let nextResult = results.removeFirst()
        return nextResult
    }

    func response(request: URLRequest) throws -> (Data, URLResponse) {
        guard results.count > callCount else { throw APIError.unknown }
        let result = results[callCount]
        callCount += 1
        switch result {
        case .success(let encodable):
            let data = (try? encoder.encode(encodable)) ?? Data()
            return (data, urlResponse(request: request))
        case .noContent:
            let data = (try? encoder.encode(EmptyResponse())) ?? Data()
            return (data, urlResponse(request: request, statusCode: .noContent))
        case .unauthorized:
            return (Data(), urlResponse(request: request, statusCode: .unauthorized))
        case .forbidden:
            return(Data(), urlResponse(request: request, statusCode: .forbidden))
        case .error(let error):
            throw error
        }
    }

    func emptyResponse(request: URLRequest) -> (Data, URLResponse) {
        return (Data(), urlResponse(request: request))
    }

    func urlResponse(request: URLRequest, statusCode: HTTPStatus = .success) -> URLResponse {
        HTTPURLResponse(url: request.url!,
                        statusCode: statusCode.statusCode,
                        httpVersion: nil,
                        headerFields: nil)! as URLResponse
    }
}

extension MockSessionProvider: SessionProvider {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        dataForRequestCalled += 1
        return try response(request: request)
    }

    func upload(for request: URLRequest, from: Data) async throws -> (Data, URLResponse) {
        uploadForRequestCalled += 1
        return try response(request: request)
    }
}

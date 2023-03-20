//
//  File.swift
//  
//
//  Created by Chris Pflepsen on 3/20/23.
//

import Foundation

@propertyWrapper
struct SafeIndex {
    private var maxIndex: Int!
    private var index: Int = 0
    init<T>(_ currentIndex: Int = 0, _ elements: [T]) {
        self.maxIndex = elements.count - 1
        self.wrappedValue = currentIndex
    }
    var wrappedValue: Int {
        get { index }
        set {
            guard newValue > 0 else {
                index = 0
                return
            }
            index = min(newValue, maxIndex)
        }
    }
}

public enum SessionResult {
    case success(Encodable)
    case noContent
    case unauthorized
    case forbidden
    case error(Error)
}

public enum DataProvider {
    case standard
    case just(Encodable)
    case error(Error)
    case queue([SessionResult])

    var sessionProvider: SessionProvider {
        switch self {
        case .standard:
            return URLSession.shared
        case .just(let encodable):
            return ConstantProvider.data(encodable).provider
        case .error(let error):
            return ConstantProvider.error(error).provider
        case .queue(let array):
            return SeriesProvider(series: .multiple(array))
        }
    }
}

public enum ConstantProvider {
        case data(Encodable)
        case error(Error)

    var provider: SessionProvider {
        switch self {
        case .data(let encodable):
            return SeriesProvider(series: .single(.success(encodable)))
        case .error(let error):
            return SeriesProvider(series: .single(.error(error)))
        }
    }
}

public enum Series {
    case single(SessionResult)
    case multiple([SessionResult])
}

public class SeriesProvider {

    // Likely need support custom encoder and decoders
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    var series: Series {
        didSet {
            resultIndex = 0
        }
    }
    private var resultIndex = 0

    public init(series: Series) {
        self.series = series
    }

    private func nextResponse(request: URLRequest) throws -> (Data, URLResponse) {
        switch series {
        case .multiple(let results):
            @SafeIndex(resultIndex, results) var nextIndex
            let result = results[nextIndex]
            resultIndex += 1
            return try response(request: request, result: result)
        case .single(let result):
            return try response(request: request, result: result)
        }
    }

    private func response(request: URLRequest, result: SessionResult) throws -> (Data, URLResponse) {
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

    private func emptyResponse(request: URLRequest) -> (Data, URLResponse) {
        return (Data(), urlResponse(request: request))
    }

    private func urlResponse(request: URLRequest, statusCode: HTTPStatus = .success) -> URLResponse {
        HTTPURLResponse(url: request.url!,
                        statusCode: statusCode.statusCode,
                        httpVersion: nil,
                        headerFields: nil)! as URLResponse
    }
}

extension SeriesProvider: SessionProvider {

    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try nextResponse(request: request)
    }

    public func upload(for request: URLRequest, from: Data) async throws -> (Data, URLResponse) {
        return try nextResponse(request: request)
    }
}

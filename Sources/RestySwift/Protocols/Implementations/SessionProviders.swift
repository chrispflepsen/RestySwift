//
//  SessionProviders.swift
//  
//
//  Created by Chris Pflepsen on 3/20/23.
//

import Foundation

enum Series {
    case single(SessionResult)
    case multiple([SessionResult])
}

class SeriesProvider {

    private var encoder: JSONEncoder!
    private var decoder: JSONDecoder!

    private(set) var index: Int = 0

    var series: Series {
        didSet {
            reset()
        }
    }

    init(series: Series,
         encoder: JSONEncoder,
         decoder: JSONDecoder) {
        self.series = series
        self.encoder = encoder
        self.decoder = decoder
    }

    func reset() {
        index = 0
    }

    private func nextResponse(request: URLRequest) throws -> (Data, URLResponse) {
        switch series {
        case .multiple(let results):
            guard let result = results[safe: index] ?? results.last else {
                throw APIError.unknown
            }
            index += 1
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

//
//  SessionProviders.swift
//  
//
//  Created by Chris Pflepsen on 3/20/23.
//

import Foundation

enum Series {
    /// A single response.
    case single(HTTPResponse)
    
    /// A series of responses.
    case multiple([HTTPResponse])
}


/// A data structure that returns a stream of data.
///
class SeriesProvider {

    /// The current index of the object that will be returned.
    private(set) var index: Int = 0

    /// The set of data the result will be pulled from.
    var series: Series {
        didSet {
            reset()
        }
    }
    
    /// Initializes a `SeriesProvider` with a `Series`.
    ///
    init(series: Series) {
        self.series = series
    }

    /// Reset the series, starting over at the beginning.
    ///
    func reset() {
        index = 0
    }

    /// Gets the next response from the provider.
    ///
    ///  - Parameters:
    ///   - encoder: The `JSONEncoder` that will be used to encode the result.
    ///   - request: The `URLRequest` to get the response for.
    /// - Returns: The next response in the series, a tuple of `Data` and a `URLResponse`.
    ///
    private func nextResponse(
        encoder: JSONEncoder,
        request: URLRequest
    ) throws -> (Data, URLResponse) {
        switch series {
        case .multiple(let results):
            guard let result = results[safe: index] ?? results.last else {
                throw APIError.unableToStubResponse
            }
            index += 1
            // Clamp the index to the end of the array.
            index = min(index, results.count - 1)
            return try response(encoder: encoder, request: request, result: result)
        case .single(let result):
            return try response(encoder: encoder, request: request, result: result)
        }
    }

    /// Translate the `HTTPResponse` in to a normalized response.
    ///
    /// - Parameters:
    ///  - encoder: The `JSONEncoder` used to encode the response.
    ///  - request: The `URLRequest` to get the response for.
    ///  - result: The `HTTPResponse` that should be translated.
    ///
    ///  - Returns: A normalized data response in the form of a tuple of `Data` and a `URLResponse`.
    ///
    private func response(
        encoder: JSONEncoder,
        request: URLRequest,
        result: HTTPResponse
    ) throws -> (Data, URLResponse) {
        switch result {
        case .success(let encodable):
            let data = (try? encoder.encode(encodable)) ?? Data()
            return (data, try urlResponse(request: request))
        case .noContent:
            return (Data(), try urlResponse(request: request, statusCode: .noContent))
        case .unauthorized:
            return (Data(), try urlResponse(request: request, statusCode: .unauthorized))
        case .forbidden:
            return(Data(), try urlResponse(request: request, statusCode: .forbidden))
        case .error(let error):
            throw error
        }
    }
    
    /// Maps a `HTTPURLResponse` to a `URLResponse`
    ///
    ///  - Parameters:
    ///   - request: The `URLRequest` to use to build the response.
    ///   - statusCode: The `HTTPStatus` for the response.
    ///  - Returns: A `URLResponse` to be returned from the provider.
    ///
    private func urlResponse(request: URLRequest, statusCode: HTTPStatus = .success) throws -> URLResponse {
        guard let response = HTTPURLResponse(request: request, statusCode: statusCode) else {
            throw APIError.unableToStubResponse
        }
        return response as URLResponse
    }
    
}

extension SeriesProvider: HTTPClient {
     public func perform(encoder: JSONEncoder, request: URLRequest) async throws -> (Data, URLResponse) {
        return try nextResponse(encoder: encoder, request: request)
    }
}

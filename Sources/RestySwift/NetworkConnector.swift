//
//  NetworkConnector.swift
//  
//
//  Created by Chris Pflepsen on 3/26/23.
//

import Foundation

/// Simple representation of a http response used with `NetworkConnector` to stub responses
public enum HTTPResponse {
    /// 401
    case unauthorized
    /// 403
    case forbidden
    /// 200
    case success(Encodable)
    /// 201
    case noContent
    /// throws error, request will fail
    case error(Error)
}

/// The `NetworkConnector` acts as a layer of abstraction on top of the network. Allowing any request to be stubbed at the networking level.
public enum NetworkConnector {
    /// URLSession.shared
    case shared

    /// Custom URLSession
    case urlSession(URLSession)

    /// Single result response
    case single(HTTPResponse)

    /// Queue of responses
    case queue([HTTPResponse])

    internal var dataProvider: APIDataProvider {
        switch self {
        case .shared:
            return URLSession.shared
        case .urlSession(let urlSession):
            return urlSession
        case .single(let sessionResult):
            return SeriesProvider(series: .single(sessionResult))
        case .queue(let array):
            return SeriesProvider(series: .multiple(array))
        }
    }
}

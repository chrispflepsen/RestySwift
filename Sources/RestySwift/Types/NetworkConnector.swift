//
//  NetworkConnector.swift
//  
//
//  Created by Chris Pflepsen on 3/26/23.
//

import Foundation

public enum SessionResult {
    /// 401
    case unauthorized
    /// 403
    case forbidden
    /// 200
    case success(Encodable)
    /// 201
    case noContent
    /// error
    case error(Error)
}

public enum NetworkConnector {
    case shared
    case urlSession(URLSession)
    case single(SessionResult)
    case queue([SessionResult])

    internal func sessionProvider(forApi api: API) -> SessionProvider {
        switch self {
        case .shared:
            return Self.urlSession(.shared).sessionProvider(forApi: api)
        case .urlSession(let urlSession):
            return urlSession
        case .single(let sessionResult):
            return SeriesProvider(series: .single(sessionResult),
                                  encoder: api.encoder,
                                  decoder: api.decoder)
        case .queue(let array):
            return SeriesProvider(series: .multiple(array),
                                  encoder: api.encoder,
                                  decoder: api.decoder)
        }
    }
}

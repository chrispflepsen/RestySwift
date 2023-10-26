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
    /// URLSession
    case shared
    case urlSession(URLSession)
    case single(SessionResult)
    case queue([SessionResult])

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

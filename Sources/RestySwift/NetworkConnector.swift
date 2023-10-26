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

/// The `NetworkConnector` enumeration acts as a layer of abstraction on top of the network.
///
/// - Cases:
///   - shared: Represents URLSession.shared (Default)
///   - urlSession: Represents a custom URLSession to allow fine grain control
///   - single: Represents a single response containing the provided data
///   - queue: Represents a queue of response containing the provided data
public enum NetworkConnector {
    /// URLSession.shared
    case shared

    /// Custom URLSession
    case urlSession(URLSession)

    /// Single result response
    case single(SessionResult)

    /// Queue of responses
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

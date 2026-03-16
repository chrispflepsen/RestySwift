//
//  Client.swift
//  
//
//  Created by Chris Pflepsen on 3/26/23.
//

import Foundation

/// The `Client` acts as a layer of abstraction on top of the network. Allowing any request to be stubbed at the networking level.
///
public enum Client: ClientProvider {
    /// URLSession.shared
    case shared

    /// Single result response
    case single(HTTPResponse)

    /// Queue of responses
    case queue([HTTPResponse])
    
    /// A custom connection.
    case custom(ClientProvider)

    /// The `HTTPClient` used to process requests.
    public var client: HTTPClient {
        switch self {
        case .shared:
            return URLSession.shared
        case .single(let result):
            return SeriesProvider(series: .single(result))
        case .queue(let series):
            return SeriesProvider(series: .multiple(series))
        case .custom(let connection):
            return connection.client
        }
    }
}

//
//  HTTPResponse.swift
//  RestySwift
//
//  Created by Chris Pflepsen on 3/14/26.
//

import Foundation

/// Simple representation of a http response used with `NetworkConnector` to stub responses.
public enum HTTPResponse {
    /// 401
    case unauthorized
    /// 403
    case forbidden
    /// 200
    case success(Encodable)
    /// 204
    case noContent
    /// Throws error, request will fail
    case error(Error)
}

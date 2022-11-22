//
//  CacheProvider.swift
//  API
//
//  Created by Chris Pflepsen on 11/3/22.
//

import Foundation

public protocol CacheProvider {
    func store<T: APIRequest>(object: T.Response, for: T)
    func object<T: APIRequest>(forRequest: T) -> T.Response?
}

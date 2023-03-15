//
//  MockCacheProvider.swift
//  
//
//  Created by Chris Pflepsen on 3/1/23.
//

import Foundation
@testable import RestySwift

class MockEmptyCacheProvider: CacheProvider {
    var storedObjects = 0
    var readObjects = 0

    func store<T>(object: T.Response, for: T) where T : APIRequest {
        storedObjects += 1
    }

    func object<T>(forRequest: T) -> T.Response? where T : APIRequest {
        readObjects += 1
        return nil
    }
}

class MockCacheProvider: MockEmptyCacheProvider {
    override func object<T>(forRequest: T) -> T.Response? where T : APIRequest {
        _ = super.object(forRequest: forRequest)
        return [Dog(name: "Spot", breed: "Beagle", age: 5)] as? T.Response
    }
}

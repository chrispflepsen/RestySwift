//
//  MockDataProvider.swift
//  
//
//  Created by Chris Pflepsen on 10/26/23.
//

import Foundation
@testable import RestySwift

enum TestingError: Error {
    case urlSessionUnavailibleWhileTesting
    case noSessionProviderConfigured
}

class MockDataProvider {
    private(set) var dataProvider: APIDataProvider?
    var connector: NetworkConnector? {
        didSet {
            switch connector {
            case .single, .queue:
                dataProvider = connector?.dataProvider
            default:
                break
            }
        }
    }

    var dataForRequestCalled = 0
    var callCount = 0

    let api: API

    init(api: API) {
        self.api = api
    }

    func reset() {
        dataForRequestCalled = 0
        callCount = 0
    }
}

extension MockDataProvider: APIDataProvider {
    func data(api: API, request: URLRequest) async throws -> (Data, URLResponse) {
        guard let dataProvider = dataProvider else {
            throw TestingError.noSessionProviderConfigured
        }
        dataForRequestCalled += 1
        return try await dataProvider.data(api: api, request: request)
    }

}

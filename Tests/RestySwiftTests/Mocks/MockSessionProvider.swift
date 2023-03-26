//
//  MockSessionProvider.swift
//  
//
//  Created by Chris Pflepsen on 2/8/23.
//

import Foundation
@testable import RestySwift

enum TestingError: Error {
    case urlSessionUnavailibleWhileTesting
    case noSessionProviderConfigured
}

class MockSessionProvider {
    private(set) var sessionProvider: SessionProvider?
    var connector: NetworkConnector? {
        didSet {
            switch connector {
            case .single, .queue:
                sessionProvider = connector?.sessionProvider(forApi: api)
            default:
                break
            }
        }
    }

    var dataForRequestCalled = 0
    var uploadForRequestCalled = 0
    var callCount = 0

    let api: API

    init(api: API) {
        self.api = api
    }

    func reset() {
        dataForRequestCalled = 0
        uploadForRequestCalled = 0
        callCount = 0
    }
}

extension MockSessionProvider: SessionProvider {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        guard let sessionProvider = sessionProvider else {
            throw TestingError.noSessionProviderConfigured
        }
        dataForRequestCalled += 1
        return try await sessionProvider.data(for: request)
    }

    func upload(for request: URLRequest, from: Data) async throws -> (Data, URLResponse) {
        guard let sessionProvider = sessionProvider else {
            throw TestingError.noSessionProviderConfigured
        }
        uploadForRequestCalled += 1
        return try await sessionProvider.upload(for: request, from: from)
    }
}

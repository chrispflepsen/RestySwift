//
//  FailingSessionProvider.swift
//  
//
//  Created by Chris Pflepsen on 2/28/23.
//

import Foundation
@testable import RestySwift

class FailingSessionProvider: SessionProvider {
    var error: Error!

    init(error: Error) {
        self.error = error
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        throw error
    }

    func upload(for request: URLRequest, from: Data) async throws -> (Data, URLResponse) {
        throw error
    }
}

extension SessionProvider {
    static func failing(error: Error) -> SessionProvider {
        FailingSessionProvider(error: error)
    }
}

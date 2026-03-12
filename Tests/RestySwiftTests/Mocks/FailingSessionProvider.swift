//
//  FailingSessionProvider.swift
//  
//
//  Created by Chris Pflepsen on 2/28/23.
//

import Foundation
@testable import RestySwift

class FailingDataProvider: HTTPClient {
    var error: Error!

    init(error: Error) {
        self.error = error
    }

    func perform(encoder: JSONEncoder, request: URLRequest) async throws -> (Data, URLResponse) {
        throw error
    }
}

extension HTTPClient {
    static func failing(error: Error) -> HTTPClient {
        FailingDataProvider(error: error)
    }
}

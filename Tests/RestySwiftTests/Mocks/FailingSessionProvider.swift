//
//  FailingSessionProvider.swift
//  
//
//  Created by Chris Pflepsen on 2/28/23.
//

import Foundation
@testable import RestySwift

class FailingDataProvider: APIDataProvider {

    var error: Error!

    init(error: Error) {
        self.error = error
    }

    func data(api: RestySwift.API, request: URLRequest) async throws -> (Data, URLResponse) {
        throw error
    }

}

extension APIDataProvider {
    static func failing(error: Error) -> APIDataProvider {
        FailingDataProvider(error: error)
    }
}

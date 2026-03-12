//
//  NetworkConnectorTests.swift
//  RestySwift
//
//  Created by Chris Pflepsen on 3/14/26.
//

import Foundation
import Testing

@testable import RestySwift

struct NetworkConnectorTests {

    @Test func dataProvider() async throws {
        let mockConnection = MockClient(client: .single(.noContent))
        
        #expect(Client.shared.client is URLSession)
        #expect(Client.single(.noContent).client is SeriesProvider)
        #expect(Client.queue([.noContent]).client is SeriesProvider)
        #expect(Client.custom(mockConnection).client is MockClient)
    }

}

//
//  MockConnection.swift
//  RestySwift
//
//  Created by Chris Pflepsen on 3/14/26.
//

import Foundation

/// An object used to mock the connection layer for testing.
/// 
public class MockClient: ClientProvider, HTTPClient {
    /// The `HTTPClient` responsible for returning data.
    private(set) var httpClient: HTTPClient
    
    /// An array of all the `URLRequest`s  that have been sent to this connection. In order received.
    public var requests = [URLRequest]()
    
    convenience init(client: Client) {
        self.init(httpClient: client.client)
    }
    
    init<T: HTTPClient>(httpClient: T) {
        self.httpClient = httpClient
    }
    
    // MARK: - Connection Conformance
    
    public var client: HTTPClient {
        self
    }
    
    // MARK: - ResponseProvider Conformance
    
    public func perform(encoder: JSONEncoder, request: URLRequest) async throws -> (Data, URLResponse) {
        requests.append(request)
        return try await httpClient.perform(encoder: encoder, request: request)
    }
}

//
//  SessionProvider.swift
//  
//
//  Created by Chris Pflepsen on 3/20/23.
//

import Foundation

protocol SessionProvider {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
    func upload(for request: URLRequest, from: Data) async throws -> (Data, URLResponse)
}

extension URLSession: SessionProvider { }

//
//  RestyAPI.swift
//
//
//  Created by Chris Pflepsen on 10/25/23.
//

import Foundation

@testable import RestySwift

/// A API implementation that can be used for testing.
struct RestyAPI: API {
    var baseUrl: String = "http://site.test"
    var middleware: [Middleware]? = nil
}

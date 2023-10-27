//
//  RestyAPI.swift
//
//
//  Created by Chris Pflepsen on 10/25/23.
//

import Foundation

struct RestyAPI: API {
    var baseUrl: String = "http://site.test"
    var middlewares: [Middleware]? = nil
}

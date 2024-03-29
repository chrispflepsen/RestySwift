//
//  Requests.swift
//  
//
//  Created by Chris Pflepsen on 3/1/23.
//

import Foundation
@testable import RestySwift

struct TestAPI: API {
    var baseUrl: String { "https://api.site.test"}
}

struct Dog: Codable {
    let name: String
    let breed: String
    let age: Int

    static var list: [Dog] {
        [
            Dog(name: "Indy", breed: "Golden Retriever", age: 3),
            Dog(name: "Tazo", breed: "Labrador Retriever", age: 10)
        ]
    }
}

struct DogRequest: APIRequest {
    typealias Response = [Dog]
    var httpMethod: HTTPMethod { .GET }
    var path: String { "/dog" }
}

struct Cat: Codable {
    let name: String
    let age: Int
    let bell: Bool
}

struct CatRequest: APIRequest {
    typealias Response = [Cat]
    var httpMethod: HTTPMethod { .GET }
    var path: String { "/cat" }
}

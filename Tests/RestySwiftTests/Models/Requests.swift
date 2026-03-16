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

/// A dog.
struct Dog: Codable, Equatable {
    /// The name of the dog,
    let name: String
    
    /// The type of breed of the dog.
    let breed: String
    
    /// The age of the dog.
    let age: Int

    /// A list of dogs.
    static var list: [Dog] {
        [
            .nitro,
            .indy,
            .tazo,
        ]
    }
    
    /// Indy.
    static let indy = Dog(name: "Indy", breed: "Golden Retriever", age: 6)
    
    /// Nitro.
    static let nitro = Dog(name: "Nitro", breed: "Lab", age: 1)
    
    /// Tazo.
    static let tazo = Dog(name: "Tazo", breed: "Labrador Retriever", age: 10)
}

struct CreateDogRequest: Request {
    typealias Response = Dog
    var httpMethod: HTTPMethod { .POST }
    var path: String { "/dog" }
    var body: Dog
}

struct DogRequest: Request {
    typealias Response = [Dog]
    var httpMethod: HTTPMethod { .GET }
    var path: String { "/dog" }
}

struct Cat: Codable {
    let name: String
    let age: Int
    let bell: Bool
}

struct CatRequest: Request {
    typealias Response = [Cat]
    var httpMethod: HTTPMethod { .GET }
    var path: String { "/cat" }
}

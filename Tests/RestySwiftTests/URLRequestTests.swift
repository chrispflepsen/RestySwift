//
//  URLRequestTests.swift
//  RestySwift
//
//  Created by Chris Pflepsen on 3/14/26.
//

import Foundation
import Testing

@testable import RestySwift

struct URLRequestTests {

    @Test func initialize() async throws {
        let decoder = JSONDecoder()
        
        var headers = Headers()
        headers["breed"] = "Lab"
        
        var parameters = Parameters()
        parameters["name"] = .single("Indy")

        let urlRequest = try URLRequest(
            request: CreateDogRequest(body: Dog.indy),
            baseUrl: "https://wikipedia.org",
            headers: headers,
            parameters: parameters,
            encoder: JSONEncoder()
        )
        
        let data = try #require(urlRequest.httpBody)
        let result = try decoder.decode(Dog.self, from: data)
        #expect(result == Dog.indy)
        
        #expect(urlRequest.allHTTPHeaderFields?["breed"] == "Lab")
        
        let url = try #require(URL(string: "https://wikipedia.org/dog?name=Indy"))
        #expect(urlRequest.url == url)
    }

}

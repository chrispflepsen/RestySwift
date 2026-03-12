//
//  MutableRequestTests.swift
//  RestySwift
//
//  Created by Chris Pflepsen on 3/14/26.
//

import Testing

@testable import RestySwift

struct MutableRequestTests {

    /// Test initializing a `MutableRequest` with all the parameters.
    @Test func initalize() async throws {
        let subject = MutableRequest<CreateDogRequest>(
            httpMethod: .POST,
            path: "/dog/create",
            body: Dog.indy
        )
        #expect(subject.httpMethod == .POST)
        #expect(subject.path == "/dog/create")
        #expect(subject.body == Dog.indy)
    }
    
    /// Test initializing a `MutableRequest` with a `Request` object.
    @Test func initalizeWithRequest() async throws {
        let subject = MutableRequest(request: CreateDogRequest(body: Dog.indy))

        #expect(subject.httpMethod == .POST)
        #expect(subject.path == "/dog")
        #expect(subject.body == Dog.indy)
    }
    
    /// Test mutating the values of a `MutableRequest`.
    @Test func mutate() async throws {
        let subject = MutableRequest(request: CreateDogRequest(body: Dog.indy))
        subject.httpMethod = .DELETE
        subject.path = "/dog/delete"
        subject.headers = ["content/type": "dogs"]
        subject.parameters = ["good-boy": .single("true")]
        subject.body = Dog.tazo

        #expect(subject.httpMethod == .DELETE)
        #expect(subject.path == "/dog/delete")
        #expect(subject.headers == ["content/type": "dogs"])
        #expect(subject.parameters == ["good-boy": .single("true")])
        #expect(subject.body == Dog.tazo)
    }
}

//
//  TestingGrounds.swift
//  
//
//  Created by Chris Pflepsen on 3/18/23.
//

import XCTest
@testable import RestySwift

final class TestingGrounds: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        let component = PathComponent(nil) + PathComponent("Dog") + PathComponent("1") + PathComponent("edit")
        component.$path
        print(component.path)
    }

    @Resty(DogAPI(), DogRequest())
    var dog: Dog? {
        willSet {
            guard let doggy = newValue else { return }
            print("New Dog: \(doggy.name)")
        }
    }

    func testIndy() async throws {
        let api = DogAPI()
        do {
            let name = dog?.name
            _dog.update()
            let otherName = dog?.name
//            $dog.update()
            let tazo = try await api.perform(request: DogRequest())
            let indy = try await api.perform(request: DogRequest())
            XCTAssertNotNil(tazo)
        } catch let error {
            print(error)
        }


    }

}

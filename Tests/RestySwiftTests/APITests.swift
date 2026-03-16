import XCTest
@testable import RestySwift

final class APITests: XCTestCase {

    var api = TestAPI()

    func testOtherCode() async throws {
        let mock = MockClient(client: .single(.forbidden))

        let expectation = "Expect statusCode error to be thrown"
        await XCTAssertThrowsErrorAsync(try await api.perform(request: DogRequest(),
                                                              client: .custom(mock)),
                                  expectation) { error in
            switch error {
            case APIError.invalidHTTPStatus(let response):
                XCTAssertEqual(response.statusCode, .forbidden)
            default:
                XCTFail(expectation)
            }
        }
    }
}

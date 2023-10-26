import XCTest
@testable import RestySwift

final class APITests: XCTestCase {

    let authProvider = MockAuthProvider()
    let versionProvider = MockVersionProvider()
    var api = TestAPI()
    var sessionProvider: MockDataProvider!

    override func setUp() async throws {
        sessionProvider = MockDataProvider(api: api)
    }

    func testOtherCode() async throws {
        let connector: NetworkConnector = .single(.forbidden)

        let expectation = "Expect statusCode error to be thrown"
        await XCTAssertThrowsErrorAsync(try await api.perform(request: DogRequest(),
                                                                 connector: connector),
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

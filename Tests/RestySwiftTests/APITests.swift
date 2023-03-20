import XCTest
@testable import RestySwift

final class APITests: XCTestCase {

    let api = TestApi()
    let authProvider = MockAuthProvider()
    let versionProvider = MockVersionProvider()
    let sessionProvider = MockSessionProvider()
    var client: API!

    override func setUp() async throws {
        client = CustomAPI(cacheProvider: nil,
                           authProvider: authProvider,
                           versionProvider: versionProvider,
                           sessionProvider: sessionProvider)
    }

    func testOtherCode() async throws {
        sessionProvider.results = [
            .forbidden
        ]

        let expectation = "Expect statusCode error to be thrown"
        await XCTAssertThrowsErrorAsync(try await client.perform(request: DogRequest()),
                                  expectation) { error in
            switch error {
            case APIError.invalidHTTPStatus(let status):
                XCTAssertEqual(status, .forbidden)
            default:
                XCTFail(expectation)
            }
        }
    }
}

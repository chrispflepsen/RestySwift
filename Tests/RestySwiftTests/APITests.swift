import XCTest
@testable import RestySwift

final class APITests: XCTestCase {

    let api = TestApi()
    let authProvider = MockAuthProvider()
    let versionProvider = MockVersionProvider()
    let sessionProvider = MockSessionProvider()
    var client: APIClient!

    override func setUp() async throws {
        client = APIClient(api: api,
                           cacheProvider: nil,
                           authProvider: authProvider,
                           versionProvider: versionProvider,
                           sessionProvider: sessionProvider)
    }

    func testPublicClientCreation() throws {
        let client = APIClient(api: api)
        XCTAssertNotNil(client.api)
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

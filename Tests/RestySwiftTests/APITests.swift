import XCTest
@testable import RestySwift

final class APITests: XCTestCase {

    let authProvider = MockAuthProvider()
    let versionProvider = MockVersionProvider()
    var api: API!
    var sessionProvider: MockSessionProvider!

    override func setUp() async throws {
        api = CustomAPI(cacheProvider: nil,
                           authProvider: authProvider,
                           versionProvider: versionProvider)
        sessionProvider = MockSessionProvider(api: api)
    }

    func testOtherCode() async throws {
        let connector: NetworkConnector = .single(.forbidden)

        let expectation = "Expect statusCode error to be thrown"
        await XCTAssertThrowsErrorAsync(try await api.perform(request: DogRequest(),
                                                                 networkConnector: connector),
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

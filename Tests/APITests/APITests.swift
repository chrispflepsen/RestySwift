import XCTest
@testable import API

final class APITests: XCTestCase {

    override func setUp() async throws {
    }
    
    func testMimeType() async throws {
        XCTAssert("file.pdf".mimeType == "application/pdf")
    }
}

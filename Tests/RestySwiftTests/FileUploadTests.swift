//
//  FileUploadTests.swift
//  
//
//  Created by Chris Pflepsen on 3/1/23.
//

import XCTest
@testable import RestySwift

final class FileUploadTests: XCTestCase {

    let api = TestApi()
    let authProvider = MockAuthProvider()
    let versionProvider = MockVersionProvider()
    let sessionProvider = MockSessionProvider()
    var client: APIClient!

    let fileUpload = FileUpload(data: Data(count: 1024), fileName: "file.txt")

    override func setUpWithError() throws {
        client = APIClient(api: api,
                           cacheProvider: nil,
                           authProvider: authProvider,
                           versionProvider: versionProvider,
                           sessionProvider: sessionProvider)
    }

    func testFileUploadCreation() throws {
        XCTAssert(fileUpload.bodyData.count > 0)
    }

    func testMimeType() throws {
        XCTAssertEqual("file.txt".mimeType, "text/plain")
    }

    func testFileUpload() async throws {
        sessionProvider.results = [
            .success(EmptyResponse())
        ]

        let request = FileUploadRequest(path: "/upload", fileUpload: fileUpload)
        try await client.performFileUpload(request)
        XCTAssertEqual(sessionProvider.uploadForRequestCalled, 1)
    }

    func testFailure() async throws {
        sessionProvider.results = [
            .forbidden
        ]

        let request = FileUploadRequest(path: "/upload", fileUpload: fileUpload)
        let expectation = "Expect failure due to forbidden response"
        await XCTAssertThrowsErrorAsync(try await client.performFileUpload(request),
                                        expectation) { error in
            switch error {
            case APIError.invalidHTTPStatus(let status):
                XCTAssertEqual(status, .forbidden)
            default:
                XCTFail(expectation)
            }
        }
    }

    func testFailingAuth() async throws {
        sessionProvider.results = [
            .unauthorized,
            .unauthorized
        ]

        let request = FileUploadRequest(path: "/upload", fileUpload: fileUpload)
        let expectation = "Expect failure due to failing re auth"
        await XCTAssertThrowsErrorAsync(try await client.performFileUpload(request),
                                  expectation) { error in
            switch error {
            case APIError.invalidHTTPStatus(let status):
                XCTAssertEqual(status, .unauthorized)
                XCTAssertEqual(authProvider.refreshTokenCalled, 1)
                XCTAssertEqual(authProvider.injectCredentialsCalled, 2)
            default:
                XCTFail(expectation)
            }
        }
    }

    func testRefreshAuthentication() async throws {
        sessionProvider.results = [
            .unauthorized,
            .noContent
        ]

        let request = FileUploadRequest(path: "/upload", fileUpload: fileUpload)
        try await client.performFileUpload(request)
        XCTAssertEqual(authProvider.refreshTokenCalled, 1)
        XCTAssertEqual(authProvider.injectCredentialsCalled, 2)
    }

}

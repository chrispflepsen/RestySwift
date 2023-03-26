//
//  FileUploadTests.swift
//  
//
//  Created by Chris Pflepsen on 3/1/23.
//

import XCTest
@testable import RestySwift

final class FileUploadTests: XCTestCase {

    let authProvider = MockAuthProvider()
    let versionProvider = MockVersionProvider()
    var api: CustomAPI!
    var sessionProvider: MockSessionProvider!

    let fileUpload = FileUpload(data: Data(count: 1024), fileName: "file.txt")

    override func setUpWithError() throws {
        api = CustomAPI(cacheProvider: nil,
                           authProvider: authProvider,
                           versionProvider: versionProvider)
        sessionProvider = MockSessionProvider(api: api)
    }

    func testFileUploadCreation() throws {
        XCTAssert(fileUpload.bodyData.count > 0)
    }

    func testMimeType() throws {
        XCTAssertEqual("file.txt".mimeType, "text/plain")
    }

    func testFileUpload() async throws {
        sessionProvider.connector = .single(.success(EmptyResponse()))

        let request = FileUploadRequest(path: "/upload", fileUpload: fileUpload)
        try await api.performFileUpload(request,
                                        sessionProvider: sessionProvider)
        XCTAssertEqual(sessionProvider.uploadForRequestCalled, 1)
    }

    func testFailure() async throws {
        sessionProvider.connector = .queue([
            .forbidden
        ])

        let request = FileUploadRequest(path: "/upload", fileUpload: fileUpload)
        let expectation = "Expect failure due to forbidden response"
        await XCTAssertThrowsErrorAsync(try await api.performFileUpload(request,
                                                                        sessionProvider: sessionProvider),
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
        sessionProvider.connector = .queue([
            .unauthorized,
            .unauthorized
        ])

        let request = FileUploadRequest(path: "/upload", fileUpload: fileUpload)
        let expectation = "Expect failure due to failing re auth"
        await XCTAssertThrowsErrorAsync(try await api.performFileUpload(request,
                                                                        sessionProvider: sessionProvider),
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
        sessionProvider.connector = .queue([
            .unauthorized,
            .noContent
        ])

        let request = FileUploadRequest(path: "/upload", fileUpload: fileUpload)
        try await api.performFileUpload(request,
                                        sessionProvider: sessionProvider)
        XCTAssertEqual(authProvider.refreshTokenCalled, 1)
        XCTAssertEqual(authProvider.injectCredentialsCalled, 2)
    }

}

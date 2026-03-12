//
//  URLResponseExtensionTests.swift
//  RestySwift
//
//  Created by Chris Pflepsen on 3/14/26.
//

import Foundation
import Testing

@testable import RestySwift

struct URLResponseExtensionTests {
    
    var url: URL
    var request: URLRequest
    var decoder: JSONDecoder
    
    init() throws {
        url = try #require(URL(string: "https://wikipedia.org"))
        request = URLRequest(url: url)
        decoder = JSONDecoder()
    }

    @Test(arguments: HTTPStatus.allCases)
    func statusCode(statusCode: HTTPStatus) async throws {
        guard let response = HTTPURLResponse(request: request, statusCode: statusCode) else {
            throw APIError.unknown
        }
        let urlResponse = response as URLResponse
        #expect(urlResponse.httpStatus.statusCode == statusCode.statusCode)
    }
    
    @Test func statusCodeError() async throws {
        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
        #expect(response.httpStatus == .unknown)
    }
    
    @Test func headers() async throws {
        let headers: [String: String] = [
            "dog": "indiana"
        ]
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: headers)
        #expect(httpResponse?.headers == [
            "dog": "indiana"
        ])
        
        // `URLResponse` only returns an empty dictionary.
        let urlResponse = URLResponse(url: url, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
        #expect(urlResponse.headers == [:])
    }

}

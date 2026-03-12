//
//  SeriesProviderTests.swift
//  RestySwift
//
//  Created by Chris Pflepsen on 3/14/26.
//

import Foundation
import Testing

@testable import RestySwift

struct SeriesProviderTests {
    
    var url: URL
    var request: URLRequest
    var decoder: JSONDecoder
    
    init() throws {
        url = try #require(URL(string: "https://wikipedia.org"))
        request = URLRequest(url: url)
        decoder = JSONDecoder()
    }
    
    @Test func encodingError() async throws {
        let seriesProvider = SeriesProvider(series: .single(.success(NonEncodable())))
        let response = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
        #expect(response.0 == Data())
    }
    
    // MARK: - Single

    @Test func singleSuccess() async throws {
        let seriesProvider = SeriesProvider(series: .single(.success(Dog.indy)))
        let response = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
        let result = try decoder.decode(Dog.self, from: response.0)
        #expect(result == Dog.indy)
        #expect(seriesProvider.index == 0)
    }
    
    @Test func singleUnauthorized() async throws {
        let seriesProvider = SeriesProvider(series: .single(.unauthorized))
        let response = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
        #expect(response.1.httpStatus.statusCode == 401)
        #expect(seriesProvider.index == 0)
    }
    
    @Test func singleForbidden() async throws {
        let seriesProvider = SeriesProvider(series: .single(.forbidden))
        let response = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
        #expect(response.1.httpStatus.statusCode == 403)
        #expect(seriesProvider.index == 0)
    }
    
    @Test func singleNoContent() async throws {
        let seriesProvider = SeriesProvider(series: .single(.noContent))
        let response = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
        #expect(response.1.httpStatus.statusCode == 204)
        #expect(seriesProvider.index == 0)
    }
    
    @Test func singleError() async throws {
        let seriesProvider = SeriesProvider(series: .single(.error(APIError.unsupported)))
        do {
            _ = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
            Issue.record(".error() is expected to throw")
        } catch {}
    }
    
    // MARK: - Multiple
    
    @Test func multipleSingleSuccess() async throws {
        let seriesProvider = SeriesProvider(series: .multiple([.success(Dog.indy)]))
        let response = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
        let result = try decoder.decode(Dog.self, from: response.0)
        #expect(result == Dog.indy)
        #expect(seriesProvider.index == 0)
        
        // Repeat the same value
        let nextResponse = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
        let nextResult = try decoder.decode(Dog.self, from: nextResponse.0)
        #expect(nextResult == Dog.indy)
        #expect(seriesProvider.index == 0)
    }
    
    @Test func multipleManySuccess() async throws {
        let seriesProvider = SeriesProvider(
            series: .multiple(
                [
                    .success(Dog.nitro),
                    .success(Dog.indy),
                    .success(Dog.tazo),
                ]
            )
        )
        var response = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
        var result = try decoder.decode(Dog.self, from: response.0)
        #expect(result == Dog.nitro)
        #expect(seriesProvider.index == 1)
        
        response = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
        result = try decoder.decode(Dog.self, from: response.0)
        #expect(result == Dog.indy)
        #expect(seriesProvider.index == 2)
        
        response = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
        result = try decoder.decode(Dog.self, from: response.0)
        #expect(result == Dog.tazo)
        #expect(seriesProvider.index == 2)
        
        response = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
        result = try decoder.decode(Dog.self, from: response.0)
        #expect(result == Dog.tazo)
        #expect(seriesProvider.index == 2)
        
        seriesProvider.reset()
        #expect(seriesProvider.index == 0)
        
        response = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
        result = try decoder.decode(Dog.self, from: response.0)
        #expect(result == Dog.nitro)
        #expect(seriesProvider.index == 1)
        
        seriesProvider.series = .multiple(
            [
                .success(Dog.nitro),
                .success(Dog.indy),
                .success(Dog.tazo),
            ]
        )
        #expect(seriesProvider.index == 0)
        
        response = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
        result = try decoder.decode(Dog.self, from: response.0)
        #expect(result == Dog.nitro)
        #expect(seriesProvider.index == 1)
        
        response = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
        result = try decoder.decode(Dog.self, from: response.0)
        #expect(result == Dog.indy)
        #expect(seriesProvider.index == 2)
        
        response = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
        result = try decoder.decode(Dog.self, from: response.0)
        #expect(result == Dog.tazo)
        #expect(seriesProvider.index == 2)
    }
    
    @Test func multipleUnauthorized() async throws {
        let seriesProvider = SeriesProvider(series: .multiple([.unauthorized]))
        let response = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
        #expect(response.1.httpStatus.statusCode == 401)
    }
    
    @Test func multipleForbidden() async throws {
        let seriesProvider = SeriesProvider(series: .multiple([.forbidden]))
        let response = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
        #expect(response.1.httpStatus.statusCode == 403)
    }
    
    @Test func multipleNoContent() async throws {
        let seriesProvider = SeriesProvider(series: .multiple([.noContent]))
        let response = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
        #expect(response.1.httpStatus.statusCode == 204)
    }
    
    @Test func multipleError() async throws {
        let seriesProvider = SeriesProvider(series: .multiple([.error(APIError.unsupported)]))
        do {
            _ = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
            Issue.record(".error() is expected to throw")
        } catch {}
    }
    
    @Test func multipleEmptyThrows() async throws {
        let seriesProvider = SeriesProvider(series: .multiple([]))
        do {
            _ = try await seriesProvider.perform(encoder: JSONEncoder(), request: request)
            Issue.record("Empty multiple series should throw.")
        } catch {}
    }
}

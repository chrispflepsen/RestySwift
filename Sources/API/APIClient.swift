//
//  APIClient.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

public protocol SessionProvider {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: SessionProvider { }

public struct APIClient {
    
    var api: API!
    var authProvider: AuthenticationProvider?
    var cacheProvider: CacheProvider?
    var versionProvider: VersionProvider?
    
    private let sessionProvider: SessionProvider!
    
    public init(api: API,
         authProvider: AuthenticationProvider? = nil,
         versionProvider: VersionProvider? = nil,
         sessionProvider: some SessionProvider = URLSession(configuration: .default),
         cacheProvider: CacheProvider? = nil) {
        self.api = api
        self.authProvider = authProvider
        self.versionProvider = versionProvider
        self.sessionProvider = sessionProvider
        self.cacheProvider = cacheProvider
    }
    
    public func perform<T: APIRequest>(request: T) async throws -> T.Response {
        return try await perform(request: request, attemptStatus: .initial)
    }
    
    private func perform<T: APIRequest>(request: T, attemptStatus: AttemptStatus = .initial) async throws -> T.Response {
        
        // Read from cache if availible
        let cachedObject = cacheProvider?.object(forRequest: request)
        if let cachedObject = cachedObject {
            return cachedObject
        }
        
        //Perform HTTP request
        let requestURL = api.baseUrl + (versionProvider?.versionString(forRequest: request) ?? "") + request.path
        print(requestURL)
        guard let url = URL(string: requestURL) else {
            throw APIError.unableToBuildRequest
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.injectHeaders(api.headers.merging(request.parameters ?? [:], uniquingKeysWith: { _, second in second }))
        urlRequest.httpMethod = request.httpMethod.rawValue
        if let body = request.body {
            urlRequest.httpBody = try api.encoder.encode(body)
        }
        let (data, response) = try await sessionProvider.data(for: urlRequest)
        let httpStatus = response.httpStatus
        
        // Handle re-auth (if needed)
        if attemptStatus != .statusCode401,
           httpStatus == .unauthorized,
           authProvider != nil {
            return try await handleAuthenticationNeeded(request: request)
        }
        
        guard httpStatus.isSuccess else {
            throw APIError.invalidStatus(httpStatus)
        }
        
        // Decode and store to cache
        let responseObject = try decodeJson(type: T.Response.self, data: data)
        cacheProvider?.store(object: responseObject, for: request)
        return responseObject
    }
    
    private func decodeJson<T: Decodable>(type: T.Type, data: Data) throws -> T {
        do {
            return try api.decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw APIError.invalidJSON(error)
        }
    }
    
    private func handleAuthenticationNeeded<T: APIRequest>(request: T) async throws -> T.Response {
        let unauthorizedError = APIError.invalidStatus(.unauthorized)
        guard let authProvider = authProvider else { throw unauthorizedError }
        let result = try await authProvider.refreshToken()
        guard result == .loggedIn else { throw unauthorizedError }
        return try await perform(request: request, attemptStatus: .statusCode401)
    }
    
}

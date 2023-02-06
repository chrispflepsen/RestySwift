//
//  APIClient.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

public protocol SessionProvider {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
    func upload(for request: URLRequest, from: Data) async throws -> (Data, URLResponse)
}

extension URLSession: SessionProvider { }

public struct APIClient {
    
    var api: API!
    public var authProvider: AuthenticationProvider?
    public var cacheProvider: CacheProvider?
    public var versionProvider: VersionProvider?
    
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
        let urlRequest = try buildRequest(request: request)
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

    public func performFileUpload(_ fileUpload: FileUploadRequest) async throws {
        guard let fileData = fileUpload.body?.bodyData else {
            throw APIError.unableToBuildRequest
        }
        let urlRequest = try buildRequest(request: fileUpload)
        let (_, _) = try await sessionProvider.upload(for: urlRequest, from: fileData)
    }

    private func buildRequest<T: APIRequest>(request: T) throws -> URLRequest {
        let requestURL = api.baseUrl + (versionProvider?.versionString(forRequest: request) ?? "") + request.path
        let url = try URLBuilder.build(requestURL, parameters: request.parameters, encoder: api.encoder)
        var urlRequest = URLRequest(url: url)
        urlRequest.injectHeaders(request.headers ?? api.headers)
        urlRequest.httpMethod = request.httpMethod.rawValue
        if let body = request.body {
            urlRequest.httpBody = try api.encoder.encode(body)
        }
        if let authProvider = authProvider {
            authProvider.injectCredentials(request: &urlRequest)
        }
        return urlRequest
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

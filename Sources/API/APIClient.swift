//
//  APIClient.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

protocol SessionProvider {
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
                cacheProvider: CacheProvider? = nil,
                authProvider: AuthenticationProvider? = nil,
                versionProvider: VersionProvider? = nil,
                urlSession: URLSession = URLSession(configuration: .default)) {
        self.init(api: api,
                  cacheProvider: cacheProvider,
                  authProvider: authProvider,
                  versionProvider: versionProvider,
                  sessionProvider: urlSession)
    }

    init(api: API,
         cacheProvider: CacheProvider? = nil,
         authProvider: AuthenticationProvider? = nil,
         versionProvider: VersionProvider? = nil,
         sessionProvider: some SessionProvider) {
        self.api = api
        self.cacheProvider = cacheProvider
        self.authProvider = authProvider
        self.versionProvider = versionProvider
        self.sessionProvider = sessionProvider
    }

    // MARK: - Request

    @discardableResult
    public func perform<T: APIRequest>(request: T) async throws -> T.Response {
        return try await perform(request: request, attemptStatus: .initial)
    }
    
    private func perform<T: APIRequest>(request: T, attemptStatus: AttemptStatus = .initial) async throws -> T.Response {
        
        // Read from cache if available
        let cachedObject = cacheProvider?.object(forRequest: request)
        if let cachedObject = cachedObject {
            return cachedObject
        }
        
        //Perform HTTP request
        let urlRequest = try URLRequest(request: request,
                                        api: api,
                                        versionProvider: versionProvider,
                                        authProvider: authProvider)

        let (data, response) = try await sessionProvider.data(for: urlRequest)
        let httpStatus = response.httpStatus

        guard httpStatus.isSuccess else {
            return try await handleNonSuccessStatus(request: request,
                                                    httpStatus: httpStatus,
                                                    attemptStatus: attemptStatus)
        }

        let responseObject = try decodeJson(type: T.Response.self, data: data)
        cacheProvider?.store(object: responseObject, for: request)
        return responseObject
    }

    private func handleNonSuccessStatus<T: APIRequest>(request: T, httpStatus: HTTPStatus, attemptStatus: AttemptStatus) async throws -> T.Response {
        guard attemptStatus == .initial,
              httpStatus == .unauthorized,
              let authProvider = authProvider else {
            throw APIError.invalidHTTPStatus(httpStatus)
        }

        return try await performReauth(request: request, provider: authProvider)
    }

    private func performReauth<T: APIRequest>(request: T, provider: AuthenticationProvider) async throws -> T.Response {
        let authResult = try await provider.refreshAuthentication()
        switch authResult {
        case .loggedIn:
            return try await perform(request: request, attemptStatus: .retryUnauthorized)
        case .loggedOut:
            throw APIError.invalidHTTPStatus(.unauthorized)
        }
    }

    // MARK: - File Uploads

    public func performFileUpload(_ fileUpload: FileUploadRequest) async throws {
        return try await performFileUpload(fileUpload, attemptStatus: .initial)
    }

    private func performFileUpload(_ fileUpload: FileUploadRequest, attemptStatus: AttemptStatus) async throws {
        guard let fileData = fileUpload.body?.bodyData else {
            throw APIError.unableToBuildRequest
        }
        let urlRequest = try URLRequest(request: fileUpload,
                                        api: api,
                                        versionProvider: versionProvider,
                                        authProvider: authProvider)

        let (_, response) = try await sessionProvider.upload(for: urlRequest, from: fileData)
        let httpStatus = response.httpStatus

        guard httpStatus.isSuccess else {
            return try await handleFileUploadNonSuccessStatus(request: fileUpload,
                                                              httpStatus: httpStatus,
                                                              attemptStatus: attemptStatus)
        }
    }

    private func handleFileUploadNonSuccessStatus(request: FileUploadRequest, httpStatus: HTTPStatus, attemptStatus: AttemptStatus) async throws {
        guard attemptStatus == .initial,
              httpStatus == .unauthorized,
              let authProvider = authProvider else {
            throw APIError.invalidHTTPStatus(httpStatus)
        }

        return try await performFileUploadReauth(request: request, provider: authProvider)
    }

    private func performFileUploadReauth(request: FileUploadRequest, provider: AuthenticationProvider) async throws {
        let authResult = try await provider.refreshAuthentication()
        switch authResult {
        case .loggedIn:
            return try await performFileUpload(request, attemptStatus: .retryUnauthorized)
        case .loggedOut:
            throw APIError.invalidHTTPStatus(.unauthorized)
        }
    }

    // MARK: - JSON

    private func decodeJson<T: Decodable>(type: T.Type, data: Data) throws -> T {
        do {
            return try api.decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw APIError.invalidJSON(error)
        }
    }
}

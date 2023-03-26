//
//  APIClient.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

public extension API {

    // MARK: - Public Interface

    @discardableResult
    func perform<T: APIRequest>(request: T,
                                networkConnector: NetworkConnector = .shared) async throws -> T.Response {
        return try await perform(request: request,
                                 sessionProvider: networkConnector.sessionProvider(forApi: self))
    }

    func performFileUpload(_ fileUpload: FileUploadRequest,
                           networkConnector: NetworkConnector = .shared) async throws {
        return try await performFileUpload(fileUpload,
                                           sessionProvider: networkConnector.sessionProvider(forApi: self))
    }

    // MARK: - Request

    internal func perform<T: APIRequest>(request: T,
                                         sessionProvider: SessionProvider,
                                         attemptStatus: AttemptStatus = .initial) async throws -> T.Response {
        // Read from cache if available
        let cachedObject = cacheProvider?.object(forRequest: request)
        if let cachedObject = cachedObject {
            return cachedObject
        }
        
        //Perform HTTP request
        let urlRequest = try URLRequest(request: request,
                                        api: self,
                                        versionProvider: versionProvider,
                                        authProvider: authProvider)

        let (data, response) = try await sessionProvider.data(for: urlRequest)
        let httpStatus = response.httpStatus

        guard httpStatus.isSuccess else {
            return try await handleNonSuccessStatus(request: request,
                                                    sessionProvider: sessionProvider,
                                                    httpStatus: httpStatus,
                                                    attemptStatus: attemptStatus)
        }

        let responseObject = try decodeJson(type: T.Response.self, data: data)
        cacheProvider?.store(object: responseObject, for: request)
        return responseObject
    }

    private func handleNonSuccessStatus<T: APIRequest>(request: T, sessionProvider: SessionProvider, httpStatus: HTTPStatus, attemptStatus: AttemptStatus) async throws -> T.Response {
        guard attemptStatus == .initial,
              httpStatus == .unauthorized,
              let authProvider = authProvider,
              authProvider.supportsRefresh else {
            throw APIError.invalidHTTPStatus(httpStatus)
        }
        return try await performAuthenticationRefresh(request: request, sessionProvider: sessionProvider, provider: authProvider)
    }

    private func performAuthenticationRefresh<T: APIRequest>(request: T, sessionProvider: SessionProvider, provider: AuthenticationProvider) async throws -> T.Response {
        let authResult = try await provider.refreshAuthentication()
        switch authResult {
        case .success:
            return try await perform(request: request, sessionProvider: sessionProvider, attemptStatus: .retryUnauthorized)
        case .failed:
            throw APIError.invalidHTTPStatus(.unauthorized)
        }
    }

    // MARK: - File Uploads

    internal func performFileUpload(_ fileUpload: FileUploadRequest,
                                   sessionProvider: SessionProvider,
                                    attemptStatus: AttemptStatus = .initial) async throws {
        guard let fileData = fileUpload.body?.bodyData else {
            throw APIError.unableToBuildRequest
        }
        let urlRequest = try URLRequest(request: fileUpload,
                                        api: self,
                                        versionProvider: versionProvider,
                                        authProvider: authProvider)

        let (_, response) = try await sessionProvider.upload(for: urlRequest, from: fileData)
        let httpStatus = response.httpStatus

        guard httpStatus.isSuccess else {
            return try await handleFileUploadNonSuccessStatus(request: fileUpload,
                                                              sessionProvider: sessionProvider,
                                                              httpStatus: httpStatus,
                                                              attemptStatus: attemptStatus)
        }
    }

    private func handleFileUploadNonSuccessStatus(request: FileUploadRequest, sessionProvider: SessionProvider, httpStatus: HTTPStatus, attemptStatus: AttemptStatus) async throws {
        guard attemptStatus == .initial,
              httpStatus == .unauthorized,
              let authProvider = authProvider else {
            throw APIError.invalidHTTPStatus(httpStatus)
        }

        return try await performFileUploadAuthenticationRefresh(request: request, sessionProvider: sessionProvider, provider: authProvider)
    }

    private func performFileUploadAuthenticationRefresh(request: FileUploadRequest, sessionProvider: SessionProvider, provider: AuthenticationProvider) async throws {
        let authResult = try await provider.refreshAuthentication()
        switch authResult {
        case .success:
            return try await performFileUpload(request, sessionProvider: sessionProvider, attemptStatus: .retryUnauthorized)
        case .failed:
            throw APIError.invalidHTTPStatus(.unauthorized)
        }
    }

    // MARK: - JSON

    private func decodeJson<T: Decodable>(type: T.Type, data: Data) throws -> T {
        do {
            return try self.decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw APIError.invalidJSON(error)
        }
    }
}

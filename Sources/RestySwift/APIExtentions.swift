//
//  APIExtentions.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

public extension API {

    // MARK: - Public Interface

    @discardableResult
    func perform<T: APIRequest>(request: T,
                                connector: NetworkConnector = .shared) async throws -> T.Response {

        var next: @Sendable (T) async throws -> APIResponse = { (_request) in
            return try await perform(request: _request,
                                     dataProvider: connector.dataProvider)
        }

        middlewares?.reversed().forEach { middleware in
            let temp = next
            next = {
                try await middleware.intercept($0, next: temp)
            }
        }
        
        let response = try await next(request)

        guard case .success = response.statusCode else {
            throw APIError.invalidHTTPStatus(response)
        }

        return try decodeJson(type: T.Response.self, data: response.data)
    }

//    @discardableResult
//    func perform<T: APIRequest>(request: T,
//                                connector: NetworkConnector = .shared) async throws -> (Data, URLResponse) {
//        return try await perform(request: request,
//                                 sessionProvider: connector.sessionProvider(forApi: self))
//    }

//    func performFileUpload(_ fileUpload: FileUploadRequest,
//                           connector: NetworkConnector = .shared) async throws {
//        return try await performFileUpload(fileUpload,
//                                           sessionProvider: connector.sessionProvider(forApi: self))
//    }

    // MARK: - Request

    internal func perform<T: APIRequest>(request: T,
                                         dataProvider: some APIDataProvider) async throws -> APIResponse {

        let headers = Headers(defaultHeaders: defaults?.headers,
                              requestHeaders: request.headers)

        let parameters = Parameters(defaultParameters: defaults?.parameters,
                                    requestParameters: request.parameters)

        let urlRequest = try URLRequest(request: request,
                                        baseUrl: baseUrl,
                                        headers: headers,
                                        parameters: parameters,
                                        encoder: encoder)

        let (data, response) = try await dataProvider.data(api: self, request: urlRequest)
        return APIResponse(data: data, response: response)
    }

    // MARK: - File Uploads

//    internal func performFileUpload(_ fileUpload: FileUploadRequest,
//                                   sessionProvider: SessionProvider,
//                                    attemptStatus: AttemptStatus = .initial) async throws {
//        let fileData = fileUpload.body.bodyData
//        let urlRequest = try URLRequest(request: fileUpload,
//                                        api: self,
//                                        versionProvider: versionProvider,
//                                        authProvider: authProvider)
//
//        let (_, response) = try await sessionProvider.upload(for: urlRequest, from: fileData)
//        let httpStatus = response.httpStatus
//
//        guard httpStatus.isSuccess else {
//            return try await handleFileUploadNonSuccessStatus(request: fileUpload,
//                                                              sessionProvider: sessionProvider,
//                                                              httpStatus: httpStatus,
//                                                              attemptStatus: attemptStatus)
//        }
//    }
//
//    private func handleFileUploadNonSuccessStatus(request: FileUploadRequest, sessionProvider: SessionProvider, httpStatus: HTTPStatus, attemptStatus: AttemptStatus) async throws {
//        guard attemptStatus == .initial,
//              httpStatus == .unauthorized,
//              let authProvider = authProvider else {
//            throw APIError.invalidHTTPStatus(httpStatus)
//        }
//
//        return try await performFileUploadAuthenticationRefresh(request: request, sessionProvider: sessionProvider, provider: authProvider)
//    }
//
//    private func performFileUploadAuthenticationRefresh(request: FileUploadRequest, sessionProvider: SessionProvider, provider: AuthenticationProvider) async throws {
//        let authResult = try await provider.refreshAuthentication()
//        switch authResult {
//        case .success:
//            return try await performFileUpload(request, sessionProvider: sessionProvider, attemptStatus: .retryUnauthorized)
//        case .failed:
//            throw APIError.invalidHTTPStatus(.unauthorized)
//        }
//    }

    // MARK: - JSON

    private func decodeJson<T: Decodable>(type: T.Type, data: Data) throws -> T {
        do {
            return try self.decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw APIError.invalidJSON(error)
        }
    }
}

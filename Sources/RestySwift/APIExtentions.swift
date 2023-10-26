//
//  APIExtentions.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

extension API {

    // MARK: - Public Interface

    /// Performs an asyncronous API request with the specified request.
    ///
    /// - Parameters:
    ///   - request: The API request to be performed.
    ///   - connector: The network connector to be used for the request (default is shared).
    /// - Returns: The response object of the request.
    /// - Throws: An error if the request or response processing fails.
    ///
    @discardableResult
    public func perform<T: APIRequest>(request: T,
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

        guard response.statusCode.isSuccess else {
            throw APIError.invalidHTTPStatus(response)
        }

        return try decodeJson(type: T.Response.self, data: response.data)
    }

    // MARK: - Request

    func perform<T: APIRequest>(request: T,
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

    // MARK: - JSON

    private func decodeJson<T: Decodable>(type: T.Type, data: Data) throws -> T {
        do {
            return try self.decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw APIError.invalidJSON(error)
        }
    }
}

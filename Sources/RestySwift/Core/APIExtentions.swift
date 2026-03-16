//
//  APIExtentions.swift
//  API
//
//  Created by Chris Pflepsen on 11/1/22.
//

import Foundation

extension API {
    // MARK: - Public Interface

    /// Performs an asynchronous API request with the specified request.
    ///
    /// - Parameters:
    ///   - request: The API request to be performed.
    ///   - client: The client mode to be used for the request (default is shared).
    /// - Returns: The response object of the request, decoded from the JSON of the body of the response.
    /// - Throws: An error if the request or response processing fails.
    ///
    @discardableResult
    public func perform<T: Request>(
        request: T,
        client: Client = .shared
    ) async throws -> T.Response {

        let mutableRequest = MutableRequest<T>(request: request)
        let updatedRequest = try await applyRequestTransformation(mutableRequest)
        
        var response = try await perform(
            request: updatedRequest,
            httpClient: client.client
        )
        
        response = try await applyResponseTransformation(response)

        guard response.statusCode.isSuccess else {
            throw APIError.invalidHTTPStatus(response)
        }

        return try decodeJson(type: T.Response.self, data: response.data)
    }

    // MARK: - Request

    /// Performs the `Request` using the supplied `HTTPClient`.
    ///
    /// - Parameters:
    ///  - request: The `Request` that will be performed.
    ///  - httpClient: The `HTTPClient` to use to perform the request.
    ///
    private func perform<T: Request, C: HTTPClient>(
        request: T,
        httpClient: C
    ) async throws -> Response {

        let headers = request.headers ?? [:]
        let parameters = request.parameters ?? [:]

        let urlRequest = try URLRequest(
            request: request,
            baseUrl: baseUrl,
            headers: headers,
            parameters: parameters,
            encoder: encoder
        )

        let (data, response) = try await httpClient.perform(encoder: self.encoder, request: urlRequest)
        return Response(data: data, response: response)
    }

    // MARK: - Private
    
    /// Apply the middleware transformations to the request.
    ///
    /// - Parameter inputRequest: The request that will have the transformations applied to it.
    /// - Returns: A modified `Request`.
    ///
    private func applyRequestTransformation<T: Request>(_ inputRequest: MutableRequest<T>) async throws -> MutableRequest<T> {
        guard let middleware else { return inputRequest }
        var request = inputRequest
        for nextMiddleware in middleware {
            request = try await nextMiddleware.interceptRequest(request)
        }
        return request
    }
    
    /// Apply the middleware transformations to the response.
    ///
    /// - Parameter inputResponse: The response that will have the transformations applied to it.
    /// - Returns: A modified `Response`.
    ///
    private func applyResponseTransformation(_ inputResponse: Response) async throws -> Response {
        guard let middleware = middleware?.reversed() else { return inputResponse }
        var response = inputResponse
        for nextMiddleware in middleware {
            response = try await nextMiddleware.interceptResponse(response)
        }
        return response
    }

    /// Decode the JSON for the request.
    ///
    /// - Parameters:
    ///  - type: the type of object to be decoded.
    ///  - data: the data to be decoded.
    ///
    private func decodeJson<T: Decodable>(type: T.Type, data: Data) throws -> T {
        do {
            return try self.decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw APIError.invalidJSON(error)
        }
    }
}

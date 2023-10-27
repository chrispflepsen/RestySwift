//
//  Request.swift
//  
//
//  Created by Chris Pflepsen on 3/24/23.
//

import SwiftUI

/// Encapsulates the API to make the SwiftUI bindings possible
public protocol BindingRequest: APIRequest {
    var api: API { get }
}

/// Underlying view model for the SwiftUI bindings
public class RequestObservable<T: BindingRequest>: ObservableObject {
    @Published public var result: T.Response?
    @Published public var error: Error?

    private let request: T

    public init(request: T,
         networkConnector: NetworkConnector = .shared) {
        self.request = request
        performRequest()
    }

    public func performRequest() {
        Task {
            do {
                let result = try await request.api.perform(request: request)
                await self.updateResult(result)
            } catch let error {
                await self.updateError(error)
            }
        }
    }

    @MainActor
    private func updateResult(_ result: T.Response?) {
        self.result = result
        self.error = nil
    }

    @MainActor
    private func updateError(_ error: Error) {
        self.result = result
        self.error = nil
    }
}

/// Property wrapper that binds the request to the view model data
@propertyWrapper
public struct Request<T: BindingRequest>: DynamicProperty {
    @ObservedObject private var observable: RequestObservable<T>

    public var wrappedValue: T.Response? {
        get { observable.result }
        nonmutating set { observable.result = newValue }
    }

    public var projectedValue: RequestObservable<T> { observable }

    public init(_ request: T, _ networkConnector: NetworkConnector = .shared) {
        self.observable = RequestObservable(request: request, networkConnector: networkConnector)
    }
}

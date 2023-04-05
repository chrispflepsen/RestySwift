//
//  Request.swift
//  
//
//  Created by Chris Pflepsen on 3/24/23.
//

import Foundation
import SwiftUI

public class RequestViewModel<T: BindingRequest>: ObservableObject {
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
@propertyWrapper
public struct Request<T: BindingRequest>: DynamicProperty {
    @ObservedObject private var core: RequestViewModel<T>

    public var wrappedValue: T.Response? {
        get { core.result }
        nonmutating set { core.result = newValue }
    }

    public var projectedValue: RequestViewModel<T> { core }

    public init(_ request: T, _ networkConnector: NetworkConnector = .shared) {
        self.core = RequestViewModel(request: request, networkConnector: networkConnector)
    }
}
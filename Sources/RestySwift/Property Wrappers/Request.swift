//
//  Request.swift
//  
//
//  Created by Chris Pflepsen on 3/24/23.
//

import Foundation
import SwiftUI

public class Core<T: BindingRequest>: NSObject, ObservableObject {
    @Published var result: T.Response?
    @Published var error: Error?

    private let request: T

    init(request: T) {
        self.request = request
        super.init()
        performRequest()
    }

    func performRequest() {
        Task {
            do {
                let result = try await request.api.perform(request: request)
                DispatchQueue.main.async {
                    self.updateResult(result)
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.updateError(error)
                }
            }
        }
    }

    private func updateResult(_ result: T.Response?) {
        self.result = result
        self.error = nil
    }

    private func updateError(_ error: Error) {
        self.result = result
        self.error = nil
    }
}
@propertyWrapper
public struct Request<T: BindingRequest>: DynamicProperty {
    @ObservedObject private var core: Core<T>

    public var wrappedValue: T.Response? {
        get { core.result }
        nonmutating set { core.result = newValue }
    }

    public var projectedValue: Core<T> { core }

    public init(_ request: T) {
        self.core = Core(request: request)
    }
}

//
//  Paged.swift
//  
//
//  Created by Chris Pflepsen on 3/24/23.
//

import Foundation
import SwiftUI

final public class PagingCore<T: PagedBindingRequest>: NSObject, ObservableObject {
    @Published var result = [T.Response.Element]()
    @Published var error: Error?
    @Published var currentPage: Int
    @Published var isLastPage: Bool = false

    public let request: T

    public init(_ request: T) {
        self.request = request
        self.currentPage = 1
        super.init()
        nextPage()
    }

    // TODO: Update RestySwift to add support for a paging request. we need the compiler to know that T.Response is an `Array` otherwise we can't merge the results
    public func nextPage() {
        // Maybe need to trigger some feedback that we are still at the end.
        guard !isLastPage else { return }
        Task {
            do {
                let result = try await request.api.perform(request: request)
                self.result.append(contentsOf: result)
                if result.count != request.pageSize {
                    isLastPage = true
                } else {
                    currentPage += 1
                }
            } catch let error {
                self.error = error
            }
        }
    }
}

@propertyWrapper
public struct Paged<T: PagedBindingRequest>: DynamicProperty {
    @ObservedObject private var core: PagingCore<T>

    public var wrappedValue: [T.Response.Element] {
        get { core.result }
        nonmutating set {  }
    }

    public var projectedValue: PagingCore<T> { core }

    public init(_ request: T) {
        self.core = PagingCore(request)
    }
}


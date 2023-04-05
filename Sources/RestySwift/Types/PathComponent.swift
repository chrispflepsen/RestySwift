//
//  PathComponent.swift
//  
//
//  Created by Chris Pflepsen on 4/5/23.
//

import Foundation

@propertyWrapper struct LeadingSlash {
    private var value: String? = nil
    var wrappedValue: String? {
        get { value }
        set {
            guard let component = newValue else {
                value = nil
                return
            }
            guard component.hasPrefix("/") else {
                value = "/" + component
                return
            }
            value = component
        }
    }
}

struct PathComponent {

    @LeadingSlash var path: String?

    init(_ path: String?) {
        self.path = path
    }

    static func +(lhs: PathComponent, rhs: PathComponent) -> PathComponent {
        return PathComponent((lhs.path ?? "") + (rhs.path ?? ""))
    }
}

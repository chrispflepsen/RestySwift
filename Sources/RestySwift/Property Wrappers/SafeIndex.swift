//
//  SafeIndex.swift
//  
//
//  Created by Chris Pflepsen on 3/25/23.
//

import Foundation

//@propertyWrapper
//struct SafeIndex {
//    private var maxIndex: Int!
//    private var index: Int = 0
//    init<T>(wrappedValue: Int, _ elements: [T]) {
//        self.maxIndex = elements.count - 1
//        self.wrappedValue = wrappedValue
//    }
//    var wrappedValue: Int {
//        get { index }
//        nonmutating set {
//            guard newValue > 0 else {
//                index = 0
//                return
//            }
//            index = min(newValue, maxIndex)
//        }
//    }
//    var projectedValue: SafeIndex {
//        get { self }
//        set { }
//    }
//
//    func increment() {
//        let nextValue = index + 1
//        self.wrappedValue = nextValue
//    }
//}

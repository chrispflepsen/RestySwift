//
//  CollectionExtensions.swift
//  
//
//  Created by Chris Pflepsen on 3/25/23.
//

import Foundation

extension Collection {
    /// Returns the `Element` or `nil` if the `index` is out of bounds.
    ///
    /// - Parameter index: The index of the item to be returned from the array.
    /// 
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

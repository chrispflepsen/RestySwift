//
//  CollectionExtensions.swift
//  
//
//  Created by Chris Pflepsen on 3/25/23.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

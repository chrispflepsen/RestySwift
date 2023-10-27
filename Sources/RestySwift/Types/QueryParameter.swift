//
//  QueryParameter.swift
//
//
//  Created by Chris Pflepsen on 10/26/23.
//

import Foundation

/// Representation of a single field in a url query
public enum QueryParameter {
    case single(String)
    case array([String])
}

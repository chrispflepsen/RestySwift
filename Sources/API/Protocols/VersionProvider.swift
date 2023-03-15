//
//  VersionProvider.swift
//  
//
//  Created by Chris Pflepsen on 3/2/23.
//

import Foundation

public protocol VersionProvider {
    /// The version string will be applied between the baseUrl and the request path:
    /// <api.baseUrl><VersionProvider.versionString><request.path>
    /// The version string must begin with a forward slash "/" to be valid
    func versionString(forRequest: some APIRequest) -> String
}

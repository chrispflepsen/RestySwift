//
//  File.swift
//  
//
//  Created by Chris Pflepsen on 2/6/23.
//

import Foundation

public struct FileUploadRequest {
    public var httpMethod: HTTPMethod = .POST
    public var path: String
    public var body: FileUpload?

    public init(path: String, fileUpload: FileUpload) {
        self.path = path
        self.body = fileUpload
    }
}

extension FileUploadRequest: APIRequest {
    public typealias Body = FileUpload
    public typealias Response = EmptyBody
}

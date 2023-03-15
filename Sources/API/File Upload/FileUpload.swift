//
//  FileUpload.swift
//  
//
//  Created by Chris Pflepsen on 2/6/23.
//

import Foundation
import UniformTypeIdentifiers

extension NSMutableData {
    fileprivate func append(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.append(data)
    }
}

extension String {
    fileprivate var fileUrl: URL {
        if #available(iOS 16.0, *) {
            return URL(filePath: self)
        } else {
            return URL(fileURLWithPath: self)
        }
    }

    var mimeType: String {
        let uti = UTType(filenameExtension: fileUrl.pathExtension)
        return uti?.preferredMIMEType ?? ""
    }
}

public struct FileUpload: Encodable {
    let id = UUID()
    var name: String = "file"
    let data: Data
    let fileName: String

    var idString: String { id.uuidString }

    var bodyData: Data {
        let body = NSMutableData()
        body.append("--\(idString)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n")
        body.append("Content-Type: \(fileName.mimeType)\r\n\r\n")
        body.append(data)
        body.append("\r\n")
        body.append("--\(idString)--\r\n")
        return Data(body)
    }

    public init(data: Data, fileName: String) {
        self.data = data
        self.fileName = fileName
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(bodyData)
    }
}


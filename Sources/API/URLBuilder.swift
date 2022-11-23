//
//  URLBuilder.swift
//  
//
//  Created by Chris Pflepsen on 11/22/22.
//

import Foundation

enum URLBuilder {
    static func build(_ urlString: String, parameters: [String: QueryParameter]?) throws -> URL {
        guard let parameters = parameters,
              !parameters.isEmpty else {
            return try buildFromString(string: urlString)
        }
        return try buildFromComponents(urlString, parameters: parameters)
    }
    
    private static func buildFromString(string: String) throws -> URL {
        guard let url = URL(string: string) else {
            throw APIError.unableToBuildRequest
        }
        return url
    }
    
    private static func buildFromComponents(_ urlString: String, parameters: [String: QueryParameter]) throws -> URL  {
        var components = URLComponents(string: urlString)
        var items = [URLQueryItem]()
        for (key, value) in parameters {
            switch value {
            case .single(let string):
                items.append(URLQueryItem(name: key, value: string))
            case .array(let array):
                array.forEach {
                    items.append(URLQueryItem(name: key, value: $0))
                }
            }
        }
        components?.queryItems = items
        guard let url = components?.url else {
            throw APIError.unableToBuildRequest
        }
        return url
    }
}



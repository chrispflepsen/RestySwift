//
//  URLBuilder.swift
//  
//
//  Created by Chris Pflepsen on 11/22/22.
//

import Foundation

enum URLBuilder {
    static func build(_ host: String, path: String? = nil, parameters: [String: QueryParameter]? = nil) throws -> URL {
        guard let baseUrl = URL(string: host) else { throw APIError.unableToBuildRequest }
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
//        components.host = host
        if let path = path {
            components?.path = path
        }
        if let parameters = parameters {
            components?.queryItems = buildQueryItem(parameters)
        }
        guard let url = components?.url else { throw APIError.unableToBuildRequest }
        return url
    }

    private static func buildQueryItem(_ parameters: [String: QueryParameter]) -> [URLQueryItem] {
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
        return items
    }
}

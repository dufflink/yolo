//
//  API.Endpoint.swift
//  Yolo
//
//  Created by Maxim Skorynin on 01.12.2022.
//

import Foundation

extension API.Endpoint {
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        
        components.host = host
        components.path = path
        
        let queryItems = queryItems.map { item in
            URLQueryItem(name: item.key, value: item.value)
        }
        
        components.queryItems = queryItems
        return components.url
    }
    
    var urlRequest: URLRequest? {
        guard let url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = methodType.stringValue
        request.allHTTPHeaderFields = headers
        
        return request
    }
    
}

extension API.Endpoint {
    
    enum MethodType {
        case GET
        case POST(data: Data?)
        
        var stringValue: String {
            switch self {
            case .GET:
                return "GET"
            case .POST:
                return "POST"
            }
        }
    }
    
}

extension API.Endpoint {
    
    enum Schedule: String {
        case ascending
        case descending
        
        var sortParam: String {
            return self == .ascending ? "scheduled_at" : "-scheduled_at"
        }
    }
    
}

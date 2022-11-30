//
//  API.swift
//  Yolo
//
//  Created by Maxim Skorynin on 23.10.2022.
//

import Foundation

struct API {
    
    enum Endpoint {
        
        case matches(game: Game, status: Match.Status, schedule: Schedule)
        
    }
    
}

extension API.Endpoint {
    
    var host: String { "api.pandascore.co" }
    
    var path: String {
        switch self {
            case let .matches(game, _, _):
                return "/\(game.rawValue)/matches"
            }
    }
    
    var methodType: MethodType {
        switch self {
            case .matches:
                return .GET
            }
    }
    
    var queryItems: [String: String] {
        var items: [String: String] = [:]
        
        switch self {
            case let .matches(_, status, schedule):
                items = [
                    "filter[\(status.rawValue)]": "true",
                    "sort": "\(schedule.sortParam)"
                ]
            }
        
        return items
    }
    
    var headers: [String: String] {
        return [
            "accept": "application/json",
            "authorization": "Bearer PewbAA9aH9KNfqKOfIUSWEMM3r2vLIlmLt9Gw8w_9ufX9wT3pZY"
        ]
    }
    
}

extension API {
    
    func getMatches(game: Game, status: Match.Status, schedule: API.Endpoint.Schedule) async throws -> [Match] {
        let endpoint: Endpoint = .matches(game: game, status: status, schedule: schedule)
        return try await fetch(endpoint) ?? []
    }
    
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T? {
        guard let urlRequest = endpoint.urlRequest else {
            print("URL Request is nil")
            return nil
        }
        
        let session = URLSession.shared
        //TODO: Logger
        
        let (data, _) = try await session.data(for: urlRequest)
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
}

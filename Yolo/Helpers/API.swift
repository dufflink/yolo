//
//  API.swift
//  Yolo
//
//  Created by Maxim Skorynin on 23.10.2022.
//

import Combine
import Foundation

extension API.Request {
    
    enum Schedule: String {
        case ascending
        case descending
        
        var sortParam: String {
            return self == .ascending ? "scheduled_at" : "-scheduled_at"
        }
    }
    
}

final class API {
    
    enum Game: String, Identifiable {
        
        var id: UUID {
            return .init()
        }
        
        case dota2
        case csgo
        
        var iconName: String {
            switch self {
                case .dota2:
                    return "Dota2"
                case .csgo:
                    return "CSGO"
            }
        }
        
    }
    
    struct Request {
        
        let game: Game
        let status: Match.Status?
        
        let schedule: Schedule?
        
        var url: URL {
            var components = URLComponents(string: "https://api.pandascore.co/\(game.rawValue)/matches")!
            var queryItems: [URLQueryItem] = []
            
            if let schedule = schedule {
                queryItems += [
                    .init(name: "sort", value: schedule.sortParam)
                ]
            }
            
            if let status = status {
                queryItems += [
                    .init(name: "filter[\(status.rawValue)]", value: "true")
                ]
            }
            
            let token = "PewbAA9aH9KNfqKOfIUSWEMM3r2vLIlmLt9Gw8w_9ufX9wT3pZY"
            
            queryItems += [
                .init(name: "token", value: token)
            ]
            
            components.queryItems = queryItems
            return components.url!
        }
        
    }
    
    static func createMatchPublisher(request: Request) -> AnyPublisher<[Match], Error> {
        print(request.url)
        return URLSession.shared.dataTaskPublisher(for: request.url)
            .receive(on: DispatchQueue.global(qos: .background))
            .map(\.data)
            .decode(type: [Match].self, decoder: JSONDecoder())
            .compactMap({
                $0.filter({ !$0.opponents.isEmpty })
            })
            .eraseToAnyPublisher()
    }
    
}

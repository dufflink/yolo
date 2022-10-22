//
//  API.swift
//  Yolo
//
//  Created by Maxim Skorynin on 23.10.2022.
//

import Combine
import Foundation

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
        
        var url: URL {
            var components = URLComponents(string: "https://api.pandascore.co/\(game.rawValue)/matches")!
            var queryItems: [URLQueryItem] = [
                .init(name: "sort", value: "begin_at")
            ]
            
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

//
//  API.Game.swift
//  Yolo
//
//  Created by Maxim Skorynin on 25.10.2022.
//

import SwiftUI

extension API {
    
    enum Game: String, Identifiable {
        
        var id: UUID {
            return .init()
        }
        
        case dota2
        case csgo
        
        case valorant
        
        var iconName: String {
            switch self {
                case .dota2:
                    return "Dota2"
                case .csgo:
                    return "CSGO"
                case .valorant:
                    return "Valorant"
            }
        }
        
        var gradientColors: [Color] {
            switch self {
                case .dota2:
                    return [.red, .orange]
                case .csgo:
                    return [.blue, .purple]
                case .valorant:
                    return [.purple, .pink]
            }
        }
        
    }
    
}

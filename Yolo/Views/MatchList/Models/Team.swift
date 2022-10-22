//
//  Team.swift
//  Yolo
//
//  Created by Maxim Skorynin on 17.10.2022.
//

import Foundation

struct Team: Codable {
    
    let id: Int
    let icon: String?
    
    let name: String
    let acronym: String?
    
    static var tbd: Team {
        return .init(id: -1, icon: "Dota2", name: "TBD", acronym: "TBD")
    }
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case icon = "image_url"
        
        case name
        case acronym
    }
    
}

struct Opponent: Codable, Identifiable {
    
    let id: UUID = .init()
    let team: Team
    
    enum CodingKeys: String, CodingKey {
        
        case team = "opponent"
        
    }
    
}

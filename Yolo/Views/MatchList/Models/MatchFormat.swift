//
//  MatchFormat.swift
//  Yolo
//
//  Created by Maxim Skorynin on 17.10.2022.
//

enum MatchFormat: Int, Codable {
    
    case bo1 = 1
    case bo3 = 3
    
    case bo5 = 5
    
    var title: String {
        return "BO\(rawValue)"
    }
    
}

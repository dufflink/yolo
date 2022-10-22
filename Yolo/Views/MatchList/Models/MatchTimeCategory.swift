//
//  MatchTimeCategory.swift
//  Yolo
//
//  Created by Maxim Skorynin on 17.10.2022.
//

enum MatchTimeCategory {
    
    case live
    case comming
    
    case finished
    
    var title: String {
        switch self {
            case .live:
                return "Live"
            case .finished:
                return "Finished"
            case .comming:
                return "Comming soon"
        }
    }
    
}

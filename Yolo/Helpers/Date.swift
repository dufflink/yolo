//
//  Date.swift
//  Yolo
//
//  Created by Maxim Skorynin on 19.10.2022.
//

import Foundation

extension Date {
    
    init(iso8601 rawValue: String) {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone = .current
        
        self = formatter.date(from: rawValue)!
    }
    
}

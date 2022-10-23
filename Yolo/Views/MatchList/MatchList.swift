//
//  MatchList.swift
//  Yolo
//
//  Created by Maxim Skorynin on 12.10.2022.
//

import SwiftUI

struct MatchListSection: Identifiable {
    
    let id: UUID = .init()
    
    let timeCategory: Match.Status
    let matches: [Match]
    
}

struct MatchList: View {
    
    let matches: [Match]
    
    var body: some View {
        List(matches) { match in
            MatchListCell(match: match)
        }.listStyle(.sidebar)
    }
}

struct MatchList_Previews: PreviewProvider {
    static var previews: some View {
        MatchList(matches: [
            Match.testMatch,
            Match.testMatch,
            Match.testMatch
        ])
    }
}

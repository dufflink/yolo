//
//  MatchList.swift
//  Yolo
//
//  Created by Maxim Skorynin on 12.10.2022.
//

import SwiftUI

struct MatchListSection: Identifiable {
    
    let id: UUID = .init()
    
    let timeCategory: MatchTimeCategory
    let matches: [Match]
    
}

struct MatchList: View {
    
    let sections: [MatchListSection]
    
    var body: some View {
        List(sections) { section in
            Section {
                ForEach(section.matches) { match in
                    MatchListCell(match: match)
                }
                
            } header: {
                Text(section.timeCategory.title)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
            }
        }.listStyle(.sidebar)
    }
}

struct MatchList_Previews: PreviewProvider {
    static var previews: some View {
        let sections: [MatchListSection] = [
            .init(timeCategory: .live, matches: [
                Match.testMatch,
                Match.testMatch,
                Match.testMatch
            ])
        ]
        MatchList(sections: sections)
    }
}

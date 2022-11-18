//
//  MatchList.swift
//  Yolo
//
//  Created by Maxim Skorynin on 12.10.2022.
//

import SwiftUI

struct MatchListSection: Identifiable {
    
    let id: UUID = .init()
    let matches: [Match]
    
}

extension MatchList {
    
    func headerView<V: View>(@ViewBuilder _ view: () -> V) -> Self {
        var copy = self
        copy.headerView = AnyView(view())
        
        return copy
    }
    
}

struct MatchList: View {
    
    let matches: [Match]
    let bottomInset: CGFloat
    
    var headerView: AnyView? = nil
    
    @Binding var isLoading: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack {
                    if let headerView = headerView {
                        headerView
                    }
                    
                    if isLoading {
                        let frame = geometry.frame(in: .global)
                        ProgressView()
                            .position(x: frame.midX, y: frame.midY - 180)
                    } else {
                        if matches.isEmpty {
                            let frame = geometry.frame(in: .global)
                            
                            ZStack {
                                Text("List is empty")
                            }.frame(width: frame.width, height: frame.height - 180)
                        } else {
                            ForEach(Array(zip(matches.indices, matches)), id: \.0) { index, match in
                                VStack(alignment: .trailing) {
                                    MatchListCell(match: match)
                                    
                                    if index != matches.count - 1 {
                                        Rectangle()
                                            .padding(.leading, 42)
                                            .foregroundColor(Color.black.opacity(0.1))
                                            .frame(height: 0.5)
                                    }
                                }
                            }.padding(.horizontal, 16)
                            
                            Color.clear.padding(.bottom, bottomInset)
                        }
                    }
                }
            }
        }
    }
}

struct MatchList_Previews: PreviewProvider {
    static var previews: some View {
        MatchList(matches: [
            Match.testMatch,
            Match.testMatch,
            Match.testMatch,
            Match.testMatch,
            Match.testMatch,
            Match.testMatch,
            Match.testMatch,
            Match.testMatch,
            Match.testMatch
        ], bottomInset: 0, isLoading: .constant(false))
        .headerView {
            GameList(games: [
                .dota2, .csgo
            ], selectedGame: .constant(.dota2))
        }
    }
}

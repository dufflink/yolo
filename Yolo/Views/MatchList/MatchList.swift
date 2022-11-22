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
    
    let matchSections: [MatchSection]
    let bottomInset: CGFloat
    
    var headerView: AnyView? = nil
    
    @Binding var isLoading: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    if let headerView = headerView {
                        headerView
                    }
                    
                    if isLoading {
                        let frame = geometry.frame(in: .global)
                        ProgressView()
                            .position(x: frame.midX, y: frame.midY - 180)
                    } else {
                        if matchSections.isEmpty {
                            let frame = geometry.frame(in: .global)
                            
                            ZStack {
                                VStack {
                                    Image("Devices")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 150)
                                        .shadow(color: Color.black.opacity(0.12), radius: 4, x: 6, y: 4)
                                    Text("There aren't games".uppercased())
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(Color.gray.opacity(0.8))
                                        .padding(.top, 36)
                                }
                                
                            }.frame(width: frame.width, height: frame.height - 180)
                        } else {
                            ForEach(matchSections) { section in
                                HStack(alignment: .bottom) {
                                    /*@START_MENU_TOKEN@*/Text(section.name)/*@END_MENU_TOKEN@*/
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Color.blue.opacity(0.8))
                                        .padding(.top, 16)
                                    Rectangle()
                                        .frame(height: 0.5)
                                        .foregroundColor(Color.blue.opacity(0.4))
                                        .padding(.bottom, 8)
                                }
                                
                                ForEach(section.matches) { match in
                                    VStack(alignment: .trailing) {
                                        MatchListCell(match: match)
                                        
                                        if match.id != section.matches.last?.id {
                                            Rectangle()
                                                .padding(.leading, 42)
                                                .foregroundColor(Color.blackWhite.opacity(0.1))
                                                .frame(height: 0.5)
                                        }
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
        MatchList(matchSections: [
            MatchSection(date: .init(), matches: [
                Match.testMatch,
                Match.testMatch,
                Match.testMatch,
                Match.testMatch,
                Match.testMatch,
                Match.testMatch
            ], name: "24 November")
        ], bottomInset: 0, isLoading: .constant(false))
        .headerView {
            GameList(games: [
                .dota2, .csgo
            ], selectedGame: .constant(.dota2))
        }
    }
}

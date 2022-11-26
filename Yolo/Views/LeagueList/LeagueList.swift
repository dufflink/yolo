//
//  LeagueList.swift
//  Yolo
//
//  Created by Maxim Skorynin on 10.11.2022.
//

import SwiftUI

struct LeagueListModel: Identifiable, Hashable {
    
    let id: UUID = .init()
    
    let uid: Int
    let name: String
    
    var selected: Bool
    
    init(uid: Int = 0, name: String, selected: Bool) {
        self.uid = uid
        self.name = name
        self.selected = selected
    }
    
    init(league: Match.League) {
        uid = league.id
        name = league.name
        selected = false
    }
    
    mutating func setSelected(_ isSelected: Bool) {
        selected = isSelected
    }
    
}

struct LeagueListCell: View {
    
    @Binding var league: LeagueListModel
    
    var didSelectAction: ((Bool) -> Void)? = nil
    
    var body: some View {
        HStack {
            Image("Cup")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
                .foregroundColor(.yellow)
            
            Text(league.name)
                .fontWeight(.medium)
            Spacer()
            
            Image(systemName: league.selected ? "circle.inset.filled" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color.blue)
        }
        .opacity(league.selected ? 1 : 0.4)
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture {
            league.selected.toggle()
            didSelectAction?(league.selected)
        }
    }
    
}

struct LeagueList: View {
    
    @Binding var leagues: [LeagueListModel]
    
    var isLoading = true
    var didPressCloseButton: (() -> Void)?
    
    var body: some View {
        ZStack {
            VStack(alignment: .trailing) {
                HStack(spacing: 16) {
                    Text("Leagues")
                        .fontWeight(.bold)
                        .foregroundColor(Color.purple)
                    
                    Spacer()
                    
                    Button(action: {
                        didPressCloseButton?()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 34, height: 34)
                            .foregroundColor(Color.gray.opacity(0.5))
                    })
                }
                .padding(.leading, 34)
                .padding(.trailing, 28)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach($leagues) { league in
                            LeagueListCell(league: league)
                        }
                    }
                }
                .padding(.horizontal, 32)
                .frame(maxHeight: leagues.count > 6 ? 300 : CGFloat(leagues.count) * 50)
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.whiteBlack)
                    .padding(.horizontal, 16)
                    .padding(.vertical, -8)
                    .shadow(color: Color.blackWhite.opacity(0.1), radius: 12, x: 2, y: 2)
            )
            
            if isLoading {
                Rectangle()
                    .offset(y: 16)
                    .padding(.horizontal, 16)
                    .frame(maxHeight: leagues.count > 6 ? 300 : CGFloat(leagues.count) * 50)
                    .foregroundColor(Color.whiteBlack)
                    .overlay {
                        ProgressView()
                    }
            }
        }
    }
            
}

struct LeagueList_Previews: PreviewProvider {
    static var previews: some View {
        LeagueList(leagues: .constant([
            .init(name: "ESL Pro league", selected: false),
            .init(name: "Blast", selected: true),
            .init(name: "DCL Pro league", selected: false),
            .init(name: "First arrow season XII", selected: true),
            .init(name: "IEM Rio", selected: true)
        ]))
    }
}

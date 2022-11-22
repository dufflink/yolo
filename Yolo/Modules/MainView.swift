//
//  ContentView.swift
//  Yolo
//
//  Created by Maxim Skorynin on 12.10.2022.
//

import SwiftUI

final class GameListModel: ObservableObject {
    
    let games: [API.Game] = [
        .dota2, .csgo, .valorant
    ]
    
}

struct MainView: View {
    
    @StateObject private var matchesModel = MatchesModel()
    @StateObject private var gameListModel = GameListModel()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MatchList(matches: matchesModel.matches, bottomInset: 48, isLoading: $matchesModel.isLoading)
                    .headerView {
                        GameList(games: gameListModel.games, selectedGame: $matchesModel.currentGame)
                    }.padding(.top, 42)
                VStack(alignment: .leading) {
                    HStack(spacing: 8) {
                        Image("LogoTransparent")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                        
                    }.padding(.leading, 16)
                    
                    Spacer()
                    MatchStatusList(mathStatuses: matchesModel.availableMatchStatuses, selectedStatus: $matchesModel.selectedMatchStatus)
                    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 4, y: 4)
                }
            }
        }.onAppear {
            matchesModel.getMatches()
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

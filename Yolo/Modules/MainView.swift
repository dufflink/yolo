//
//  ContentView.swift
//  Yolo
//
//  Created by Maxim Skorynin on 12.10.2022.
//

import SwiftUI

final class GameListModel: ObservableObject {
    
    let games: [API.Game] = [
        .dota2, .csgo
    ]
    
}

struct MainView: View {
    
    @StateObject private var matchesModel = MatchesModel()
    @StateObject private var gameListModel = GameListModel()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                GeometryReader { geometry in
                    MatchList(matches: matchesModel.matches, bottomInset: 100, isLoading: $matchesModel.isLoading)
                        .headerView {
                            GameList(games: gameListModel.games, selectedGame: $matchesModel.currentGame)
                        }
                }.padding(.top, 48)
                VStack {
                    Rectangle()
                        .foregroundColor(Color.white)
                        .frame(height: 48)
                    Spacer()
                    MatchStatusList(mathStatuses: matchesModel.availableMatchStatuses, selectedStatus: $matchesModel.selectedMatchStatus)
                        .shadow(color: Color.black.opacity(0.15), radius: 12, x: 4, y: 4)
                }.padding(.bottom, 48)
            }
            .ignoresSafeArea()
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

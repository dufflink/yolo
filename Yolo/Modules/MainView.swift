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
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    GameList(games: gameListModel.games, selectedGame: $matchesModel.currentGame)
                        .padding(.leading, 8)
                    
                    MatchStatusList(mathStatuses: matchesModel.availableMatchStatuses, selectedStatus: $matchesModel.selectedMatchStatus)
                    
                    if matchesModel.isLoading {
                        ZStack(alignment: .center) {
                            ProgressView()
                        }
                        .frame(width: geometry.size.width)
                        .frame(maxHeight: .infinity)
                    } else {
                        MatchList(matches: matchesModel.matches)
                    }
                }
            }.navigationTitle("Events")
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

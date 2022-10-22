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
    
    @Published var currentGame: API.Game = .dota2
    
}

struct MainView: View {
    
    @StateObject private var matchesModel = MatchesModel()
    @StateObject private var gameListModel = GameListModel()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    GameList(games: gameListModel.games, currentGame: $gameListModel.currentGame)
                        .padding(.leading, 8)
                    if matchesModel.isLoading {
                        ZStack(alignment: .center) {
                            ProgressView()
                        }
                        .frame(width: geometry.size.width)
                        .frame(maxHeight: .infinity)
                    } else {
                        MatchList(sections: matchesModel.sections)
                    }
                }
            }.navigationTitle("Events")
        }.onAppear {
            matchesModel.getMatches(game: .dota2)
        }.onChange(of: gameListModel.currentGame) { game in
            matchesModel.getMatches(game: game)
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

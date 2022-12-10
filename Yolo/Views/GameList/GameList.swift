//
//  GameList.swift
//  Yolo
//
//  Created by Maxim Skorynin on 12.10.2022.
//

import SwiftUI

struct GameList: View {
    
    let games: [Game]
    
    @Binding var selectedGame: Game
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(games) { game in
                    GameCircle(game: game, isSelected: game == selectedGame)
                        .onTapGesture {
                            if game != selectedGame {
                                playSimpleHaptic()
                                selectedGame = game
                            }
                        }
                
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
    }
    
}

func playSimpleHaptic() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
}

struct GameList_Previews: PreviewProvider {
    static var previews: some View {
        GameList(games: [
            .dota2, .csgo, .valorant
        ], selectedGame: .constant(.csgo))
    }
}

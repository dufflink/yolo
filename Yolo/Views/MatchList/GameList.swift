//
//  GameList.swift
//  Yolo
//
//  Created by Maxim Skorynin on 12.10.2022.
//

import SwiftUI

struct GameList: View {
    
    let games: [API.Game]
    
    @Binding var selectedGame: API.Game
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(games) { game in
                    ZStack {
                        if selectedGame == game {
                            Circle()
                                .fill(
                                    LinearGradient(colors: game.gradientColors, startPoint: .top, endPoint: .bottom)
                                )
                                .frame(width: 80, height: 80)
                        } else {
                            Circle()
                                .fill(
                                    Color.gray.opacity(0.4)
                                )
                                .frame(width: 80, height: 80)
                        }
                        
                        Image(game.iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(14)
                            .frame(width: 70, height: 70)
                    }.onTapGesture {
                        selectedGame = game
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
    }
    
}

struct GameList_Previews: PreviewProvider {
    static var previews: some View {
        GameList(games: [
            .dota2, .csgo, .valorant
        ], selectedGame: .constant(.csgo))
    }
}

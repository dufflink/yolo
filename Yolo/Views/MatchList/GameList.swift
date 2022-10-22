//
//  GameList.swift
//  Yolo
//
//  Created by Maxim Skorynin on 12.10.2022.
//

import SwiftUI

struct GameList: View {
    
    let games: [API.Game]
    
    @Binding var currentGame: API.Game
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(games) { game in
                    ZStack {
                        Circle()
                            .frame(width: 80, height: 80)
                            .foregroundColor(currentGame == game ? Color.blue : Color.gray.opacity(0.4))
                        Image(game.iconName)
                            .resizable()
                            .padding(15)
                            .frame(width: 70, height: 70)
                    }.onTapGesture {
                        currentGame = game
                    }
                }
            }
            .padding(8)
        }
    }
    
}

struct GameList_Previews: PreviewProvider {
    static var previews: some View {
        GameList(games: [
            .dota2, .csgo
        ], currentGame: .constant(.dota2))
    }
}

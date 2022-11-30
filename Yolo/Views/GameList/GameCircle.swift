//
//  GameCircle.swift
//  Yolo
//
//  Created by Maxim Skorynin on 31.10.2022.
//

import SwiftUI

struct GameCircle: View {
    
    let game: Game
    let isSelected: Bool
    
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            if isSelected {
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
        }
    }
    
}

struct GameCircle_Previews: PreviewProvider {
    
    static var previews: some View {
        GameCircle(game: .csgo, isSelected: true)
    }
    
}

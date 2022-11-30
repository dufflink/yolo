//
//  ContentView.swift
//  Yolo
//
//  Created by Maxim Skorynin on 12.10.2022.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var model = MainModel()
    
    @State private var showSheet = false
    
    var body: some View {
        ZStack(alignment: .top) {
            MatchList(matchSections: model.filteredSections, bottomInset: 48, isLoading: $model.isLoading)
                .headerView {
                    GameList(games: model.availableGames, selectedGame: $model.currentGame)
                }.padding(.top, 42)
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
                    Image("LogoTransparent")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blackWhite)
                }.padding(.horizontal, 16)
                
                Spacer()
                MatchStatusList(mathStatuses: model.availableMatchStatuses, leagues: model.leagues, selectedStatus: $model.currentStatus, tapOnTrophy: {
                    setSheetState(isHidden: false)
                })
                .shadow(color: Color.black.opacity(0.15), radius: 12, x: 4, y: 4)
                .offset(y: showSheet ? -40 : .zero)
            }
            
            if model.leagues.count > 1 {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        LeagueList(leagues: $model.leagues, isLoading: model.isLoading, didPressCloseButton: {
                            withAnimation {
                                setSheetState(isHidden: true)
                            }
                        })
                        .offset(y: showSheet ? -24 : geometry.size.height)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await model.getMatches()
            }
        }
    }
    
    func setSheetState(isHidden: Bool) {
        withAnimation(isHidden ? .easeOut : .easeInOut) {
            showSheet = !isHidden
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

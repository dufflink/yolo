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
            matchList
                .padding(.top, 42)
            
            VStack(alignment: .leading) {
                header
                Spacer()
                
                matchStatusList
                    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 4, y: 4)
            }
        }
        .sheet(isPresented: $showSheet, detents: sheetDetents) {
            LeagueList(leagues: $model.leagues) {
                showSheet = false
            }
        }
        .onAppear {
            Task {
                await model.getMatches()
            }
        }
    }
    
    private var matchList: some View {
        MatchList(matchSections: model.filteredSections, bottomInset: 48, isLoading: $model.isLoading)
            .headerView {
                GameList(games: model.availableGames, selectedGame: $model.currentGame)
            }
    }
    
    private var header: some View {
        HStack(spacing: 8) {
            Image("yolo-logo")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.blackWhite)
        }.padding(.horizontal, 16)
    }
    
    private var matchStatusList: some View {
        MatchStatusList(mathStatuses: model.availableMatchStatuses, leagues: model.leagues, selectedStatus: $model.currentStatus, tapOnTrophy: {
            showSheet = true
        })
    }
    
    private var sheetDetents: [UISheetPresentationController.Detent] {
        if #available(iOS 16.0, *) {
            var detents: [UISheetPresentationController.Detent] = [.medium()]
            
            if model.leagues.count < 6 {
                detents += [
                    .custom(identifier: .init("small")) { _ in
                        return CGFloat(model.leagues.count) * 50 + 32
                    }
                ]
            }
            
            return detents
        } else {
            return [.medium()]
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

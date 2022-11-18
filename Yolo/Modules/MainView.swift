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

class EventManager: ObservableObject {
    
    @Published var events: [EventListModel] = [
        .init(name: "ESL Pro league", tier: 1, selected: false),
        .init(name: "Blast", tier: 1, selected: true),
        .init(name: "DCL Pro league", tier: 2, selected: false),
        .init(name: "First arrow season XII", tier: 3, selected: true),
        .init(name: "IEM Rio", tier: 1, selected: true)
    ]
    
}

struct MainView: View {
    
    @StateObject private var matchesModel = MatchesModel()
    @StateObject private var gameListModel = GameListModel()
    
    @StateObject private var eventManager = EventManager()
    
    @State private var showSheet = false
    
    var body: some View {
            NavigationView {
                ZStack(alignment: .top) {
                    MatchList(matches: matchesModel.matches, bottomInset: 48, isLoading: $matchesModel.isLoading)
                        .headerView {
                            GameList(games: gameListModel.games, selectedGame: $matchesModel.currentGame)
                        }.padding(.top, 42)
                    VStack(alignment: .leading) {
                        Text("Yolo")
                            .font(.system(size: 30, weight: .bold))
                            .padding(.horizontal, 16)
                        Spacer()
                        MatchStatusList(mathStatuses: matchesModel.availableMatchStatuses, selectedStatus: $matchesModel.selectedMatchStatus, events: $eventManager.events, tapOnTrophy: {
                                setSheetState(isHidden: true)
                            })
                        .shadow(color: Color.black.opacity(0.15), radius: 12, x: 4, y: 4)
                        .offset(y: showSheet ? -40 : .zero)
                    }
                    
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            EventList(events: eventManager.events, didPressCloseButton: {
                                withAnimation {
                                    setSheetState(isHidden: false)
                                }
                            }, didPressSaveButton: { events in
                                eventManager.events = events
                                
                                withAnimation {
                                    setSheetState(isHidden: false)
                                }
                            })
                            .offset(y: showSheet ? -24 : geometry.size.height)
                        }
                    }
            }
        }.onAppear {
            matchesModel.getMatches()
        }
    }
    
    func setSheetState(isHidden: Bool) {
        withAnimation(isHidden ? .easeOut : .easeInOut) {
            showSheet = isHidden
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

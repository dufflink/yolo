//
//  MainViewModel.swift
//  Yolo
//
//  Created by Maxim Skorynin on 19.10.2022.
//

import Combine
import Foundation

final class MatchesModel: ObservableObject {
    
    private var matchesRequest: AnyCancellable?
    private var cancellabels: [AnyCancellable] = []
    
    let availableMatchStatuses: [Match.Status] = [
        .running, .notStarted, .finished
    ]
    
    private var lastLoadedGame: API.Game = .dota2
    private var lastLoadedStatus: Match.Status = .notStarted
    
    @Published var currentGame: API.Game = .dota2
    @Published var selectedMatchStatus: Match.Status = .notStarted
    
    @Published var matches: [Match] = []
    @Published var isLoading = false
    
    init() {
        Publishers.CombineLatest($selectedMatchStatus, $currentGame)
            .dropFirst(1)
            .sink { [weak self] selectedMatchStatus, game in
                if selectedMatchStatus != self?.lastLoadedStatus || game != self?.lastLoadedGame {
                    self?.getMatches(game: game, status: selectedMatchStatus)
                }
        }.store(in: &cancellabels)
    }
    
    func getMatches(game: API.Game = .dota2, status: Match.Status = .notStarted) {
        matchesRequest?.cancel()
        isLoading = true
        
        matchesRequest = createMatchesPublisher(game: game, status: status)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
            }, receiveValue: { [weak self] matches in
                self?.lastLoadedGame = game
                self?.lastLoadedStatus = status
                
                guard !matches.isEmpty else {
                    self?.matches = []
                    return
                }
                
                self?.matches = matches
            })
    }
    
    private func createMatchesPublisher(game: API.Game, status: Match.Status? = nil) -> AnyPublisher<[Match], Error> {
        var schedule: API.Request.Schedule?
        
        if let status = status {
            schedule = API.Request.Schedule.ascending
            
            if status == .canceled || status == .finished {
                schedule = .descending
            }
        }
        
        let request = API.Request(game: game, status: status, schedule: schedule)
        return API.createMatchPublisher(request: request).eraseToAnyPublisher()
    }
    
}

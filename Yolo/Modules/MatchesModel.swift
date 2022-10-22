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
    
    @Published var sections: [MatchListSection] = []
    @Published var isLoading = false
    
    func getMatches(game: API.Game) {
        matchesRequest?.cancel()
        isLoading = true
        
        matchesRequest = createMatchesPublisher(game: game)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                print(completion)
            }, receiveValue: { [weak self] sections in
                guard !sections.isEmpty else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.sections = sections
                }
            })
    }
    
    private func createPublisher(game: API.Game, status: Match.Status) -> AnyPublisher<[Match], Error> {
        let request = API.Request(game: game, status: status)
        return API.createMatchPublisher(request: request).eraseToAnyPublisher()
    }
    
    private func createMatchesPublisher(game: API.Game) -> AnyPublisher<[MatchListSection], Error> {
        let a = createPublisher(game: game, status: .running)
        let b = createPublisher(game: game, status: .notStarted)
        let c = createPublisher(game: game, status: .finished)
        
        return Publishers.CombineLatest3(a, b, c).map { running, notStarted, finished in
            var sections: [MatchListSection] = []
            
            if !running.isEmpty {
                sections += [
                    .init(timeCategory: .live, matches: running)
                ]
            }
            
            if !notStarted.isEmpty {
                sections += [
                    .init(timeCategory: .comming, matches: notStarted)
                ]
            }
            
            if !notStarted.isEmpty {
                sections += [
                    .init(timeCategory: .finished, matches: finished)
                ]
            }
            
            return sections
        }.eraseToAnyPublisher()
    }
    
}

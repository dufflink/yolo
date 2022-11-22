//
//  MainViewModel.swift
//  Yolo
//
//  Created by Maxim Skorynin on 19.10.2022.
//

import Combine
import Foundation

struct MatchSection: Identifiable {
    
    let id: UUID = .init()
    
    let date: Date
    let matches: [Match]
    
    let name: String
    
}

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
    
    @Published var isLoading = false
    @Published var sections: [MatchSection] = []
    
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
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .sink(receiveCompletion: { [weak self] completion in
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            }, receiveValue: { [weak self] matches in
                self?.lastLoadedGame = game
                self?.lastLoadedStatus = status
                
                let calendar = Calendar.current
                let dict = Dictionary(grouping: matches, by: { calendar.startOfDay(for: $0.beginDate) })
                
                let sections = dict.map { date, matches in
                    let name = self?.getSectionName(from: date) ?? ""
                    return MatchSection(date: date, matches: matches, name: name)
                }.sorted(by: status == .finished ? { $0.date > $1.date } : { $0.date < $1.date })
                
                DispatchQueue.main.async {
                    self?.sections = sections
                }
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
    
    private func getSectionName(from date: Date) -> String {
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            return "Today"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        dateFormatter.locale = Locale(identifier: "en_US")

        return dateFormatter.string(from: date)
    }
    
}

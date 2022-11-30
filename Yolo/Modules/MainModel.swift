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
    let name: String
    
    let date: Date
    let matches: [Match]    
    
}

final class MainModel: ObservableObject {
    
    private var cancellabels: [AnyCancellable] = []
    
    let availableMatchStatuses: [Match.Status] = [
        .running, .notStarted, .finished
    ]
    
    let availableGames: [Game] = [
        .dota2, .csgo, .valorant
    ]
    
    private let api = API()
    private let queue = DispatchQueue.global(qos: .utility)
    
    private var lastLoadedGame: Game = .dota2
    private var lastLoadedStatus: Match.Status = .notStarted
    
    private var savedSelectedLeagues: [Game: [Match.Status: [Int]]] = [:]
    
    @Published private var matches: [Match] = []
    
    @Published var currentGame: Game = .dota2
    @Published var currentStatus: Match.Status = .notStarted
    
    @Published var isLoading = true
    
    @Published var filteredSections: [MatchSection] = []
    @Published var leagues: [LeagueListModel] = []
    
    init() {
        availableGames.forEach {
            savedSelectedLeagues[$0] = [:]
            
            for status in availableMatchStatuses {
                savedSelectedLeagues[$0]?[status] = []
            }
        }
        
        Publishers.CombineLatest($currentStatus, $currentGame)
            .dropFirst(1)
            .receive(on: DispatchQueue.main)
            .sink { [self] selectedMatchStatus, game in
                if selectedMatchStatus != lastLoadedStatus || game != lastLoadedGame {
                    Task {
                        await getMatches(game: game, status: selectedMatchStatus)
                    }
                }
        }.store(in: &cancellabels)
        
        $matches
            .dropFirst(1)
            .receive(on: queue)
            .sink { matches in
                var leagues: [LeagueListModel] = []
                
                let leaguesSet = Set(matches.map { $0.league })
                let sortedLeagues = Array(leaguesSet).map { LeagueListModel(league: $0) }.sorted(by: { $0.name < $1.name })
                
                if let savedSalectedLeagues = self.savedSelectedLeagues[self.lastLoadedGame]?[self.currentStatus] {
                    leagues = sortedLeagues.map {
                        var league = $0
                        league.setSelected(savedSalectedLeagues.contains($0.uid))
                        return league
                    }
                }
                
                DispatchQueue.main.async {
                    self.leagues = leagues
                }
                
            }.store(in: &cancellabels)
        
        $leagues
            .dropFirst(1)
            .receive(on: queue)
            .sink { leagues in
                defer {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
                
                guard !leagues.isEmpty else {
                    DispatchQueue.main.async {
                        self.filteredSections = []
                    }
                    return
                }
                
                let selected = leagues.filter { $0.selected }.map { $0.uid }
                
                guard !selected.isEmpty else {
                    let sections = self.makeSections(for: self.matches, status: self.currentStatus)
                    
                    DispatchQueue.main.async {
                        self.filteredSections = sections
                    }
                    
                    return
                }
                
                self.savedSelectedLeagues[self.currentGame]?[self.currentStatus] = selected
                
                let filteredMatches = self.matches.filter { selected.contains($0.league.id) }
                let sections = self.makeSections(for: filteredMatches, status: self.currentStatus)
                
                DispatchQueue.main.async {
                    self.filteredSections = sections
                }
        }.store(in: &cancellabels)
    }
    
    func getMatches(game: Game = .dota2, status: Match.Status = .notStarted) async {
        isLoading = true
        
        var schedule: API.Endpoint.Schedule = .ascending
            
        if status == .canceled || status == .finished {
            schedule = .descending
        }
        
        do {
            lastLoadedGame = game
            lastLoadedStatus = status
            
            matches = try await api.getMatches(game: game, status: status, schedule: schedule)
        } catch {
            isLoading = false
            print(error.localizedDescription)
        }
    }
    
    private func makeSections(for matches: [Match], status: Match.Status) -> [MatchSection] {
        let calendar = Calendar.current
        let dict = Dictionary(grouping: matches, by: { calendar.startOfDay(for: $0.beginDate) })
        
        return dict.map { date, matches in
            let name = getSectionName(from: date)
            return MatchSection(name: name, date: date, matches: matches)
        }.sorted(by: status == .finished ? { $0.date > $1.date } : { $0.date < $1.date })
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

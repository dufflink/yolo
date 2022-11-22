//
//  Match.swift
//  Yolo
//
//  Created by Maxim Skorynin on 17.10.2022.
//

import Foundation

extension Match {
    
    enum Status: String, Codable, Identifiable {
        
        case running
        case finished
        
        case canceled
        case notStarted = "not_started"
        
        var id: UUID {
            return .init()
        }
        
        var title: String {
            switch self {
                case .running:
                    return "Live"
                case .finished:
                    return "Finished"
                case .canceled:
                    return "Canceled"
                case .notStarted:
                    return "Soon"
            }
        }
        
        var order: Int {
            switch self {
                case .running:
                    return 0
                case .finished:
                    return 2
                case .canceled:
                    return 3
                case .notStarted:
                    return 1
            }
        }
        
    }
    
}

extension Match {
    
    struct Result: Codable {
        
        let score: Int
        let teamID: Int
        
        enum CodingKeys: String, CodingKey {
            
            case score
            case teamID = "team_id"
            
        }
        
    }
    
}

extension Match {
    
    struct League: Codable {
        
        let name: String
        
    }
    
}

struct Match: Identifiable, Codable {
    
    let uid: UUID = .init()
    let id: Int
    
    let opponents: [Opponent]
    let status: Status
    
    let results: [Result]
    
    let numberOfGames: Int
    let beginDate: Date
    
    let winnderID: Int?
    let league: League
    
    enum CodingKeys: String, CodingKey {

        case id
        case opponents
        
        case status
        case results
        
        case numberOfGames = "number_of_games"
        case beginDate = "begin_at"
        
        case winnderID = "winner_id"
        case league
        
    }
    
    // MARK: - Life Cycle
    
    init(id: Int, opponents: [Opponent], status: Status, results: [Result], numberOfGames: Int, beginDate: Date, winnderID: Int? = nil, league: League) {
        self.id = id
        self.opponents = opponents
        self.status = status
        self.results = results
        self.numberOfGames = numberOfGames
        self.beginDate = beginDate
        self.winnderID = winnderID
        self.league = league
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        opponents = try container.decode([Opponent].self, forKey: .opponents)

        status = try container.decode(Match.Status.self, forKey: .status)
        results = try container.decode([Match.Result].self, forKey: .results)

        numberOfGames = try container.decode(Int.self, forKey: .numberOfGames)
        winnderID = try? container.decode(Int.self, forKey: .winnderID)

        league = try container.decode(League.self, forKey: .league)

        if let iso8601 = try? container.decode(String.self, forKey: .beginDate) {
            beginDate = .init(iso8601: iso8601)
        } else {
            beginDate = .init()
        }
    }
    
    // MARK: - Properties
    
    func score(teamID: Int) -> Int? {
        return results.first { $0.teamID == teamID }?.score
    }
    
    var startingTime: String {
        let calendar = Calendar.current

        if calendar.isDateInToday(beginDate) {
            return "\(time)"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, HH:mm"

        return dateFormatter.string(from: beginDate)
    }
    
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: beginDate)
    }
    
}

extension Match {
    
    static var testMatch: Match {
        return .init(id: 1234, opponents: [
            .init(team: .init(id: 1, icon: "https", name: "Natus Vincere", acronym: "NAVI")),
            .init(team: .init(id: 2, icon: "https", name: "Virtus Pro", acronym: "VP"))
        ], status: .notStarted, results: [
            .init(score: 2, teamID: 1),
            .init(score: 0, teamID: 2)
        ], numberOfGames: 3, beginDate: .init(), league: .init(name: "Game League"))
    }
    
    static func getTestMatch(status: Status) -> Match {
        return .init(id: 1234, opponents: [
            .init(team: .init(id: 1, icon: nil, name: "Natus Vincere", acronym: "NAVI")),
            .init(team: .init(id: 2, icon: nil, name: "Virtus Pro", acronym: "VP"))
        ], status: status, results: [
            .init(score: 2, teamID: 1),
            .init(score: 0, teamID: 2)
        ], numberOfGames: 3, beginDate: .init(), league: .init(name: "Game League"))
    }
    
}

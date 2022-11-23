//
//  MatchListCell.swift
//  Yolo
//
//  Created by Maxim Skorynin on 17.10.2022.
//

import SwiftUI
import Kingfisher

struct MatchListCell: View {
    
    let match: Match
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    if match.opponents.count == 1 {
                        TeamView(team: match.opponents.first!.team)
                        TeamView(team: .tbd)
                    } else {
                        if match.status == .notStarted {
                            ForEach(match.opponents) { opponent in
                                TeamView(team: opponent.team)
                            }
                        } else {
                            ForEach(match.opponents) { opponent in
                                let score = match.score(teamID: opponent.team.id)
                                let isWinner = match.winnderID == opponent.team.id
                                
                                TeamView(team: opponent.team, score: score, isWinner: isWinner)
                            }
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("BO\(match.numberOfGames)")
                        .roundedText(background: Color.orange)
                }.padding(.vertical, 12)
            }
            
            HStack {
                Text(match.time)
                        .font(.system(size: 14, weight: .heavy))
                
                if match.status == .running {
                    Circle()
                        .foregroundColor(.red)
                        .frame(width: 6, height: 6)
                }
                Spacer()
                Text(match.league.name)
                    .lineLimit(1)
                    .foregroundColor(Color.gray.opacity(0.8))
                    .font(.system(size: 14))
                Image("Cup")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(Color.gray.opacity(0.6))
                
            }
            .padding(.leading, 42)
            .padding(.vertical, 4)
            
        }
    }
    
    struct TeamView: View {
        
        let team: Team
                                
        var score: Int? = nil
        var isWinner = false
        
        var body: some View {
            HStack(spacing: 12) {
                if let icon = team.icon, let url = URL(string: icon) {
                    KFImage.url(url)
                        .resizable()
                        .placeholder {
                            Rectangle()
                                .foregroundColor(Color.blackWhite.opacity(0.1))
                                .frame(width: 32, height: 32)
                        }
                        .cacheOriginalImage()
                        .retry(maxCount: 3, interval: .seconds(5))
                        .fade(duration: 0.25)
                        .cancelOnDisappear(true)
                        .frame(width: 32, height: 32)
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "shield.lefthalf.filled")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .foregroundColor(Color.blackWhite.opacity(0.2))
                }
                
                if let score = score {
                    Text("\(score)")
                        .roundedText(background: isWinner ? Color.green : Color.gray.opacity(0.6))
                }
                
                Text(team.name)
                    .padding(.leading, -4)
            }.padding(.vertical, 8)
        }
        
    }
    
}

struct MatchListCell_Previews: PreviewProvider {
    static var previews: some View {
        MatchListCell(match: Match.getTestMatch(status: .finished))
            .background(Color.gray.opacity(0.3))
    }
}

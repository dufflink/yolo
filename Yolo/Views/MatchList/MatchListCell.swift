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
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                if match.opponents.count == 1 {
                    TeamView(team: match.opponents.first!.team)
                    TeamView(team: .tbd)
                } else {
                    ForEach(match.opponents) { opponent in
                        TeamView(team: opponent.team)
                    }
                }
            }
            
            Spacer()
            
            VStack {
                VStack {
                    switch match.status {
                        case .notStarted:
                            Text("BO\(match.numberOfGames)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.orange)
                                .cornerRadius(4)
                        default:
                            Text("BO\(match.numberOfGames)")
                                .font(.system(size: 14, weight: .medium))
                            HStack {
                                Text("\(match.results.first?.score ?? 8):\(match.results.last?.score ?? 8)")
                                    .padding(.horizontal, 6)
                                    .foregroundColor(Color.white)
                            }
                            .background(Color.green)
                            .cornerRadius(4)
                    }
                }
                
                Spacer()
                
                if match.isLive {
                    Text("LIVE")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color.red)
                } else {
                    VStack {
                        Text(match.startingTime)
                            .foregroundColor(Color.black.opacity(0.4))
                            .font(.system(size: 12, weight: .medium))
                    }
                }
            }.padding(.vertical, 20)
        }
    }
    
    struct TeamView: View {
        
        let team: Team
        
        var body: some View {
            HStack(spacing: 0) {
                KFImage.url(URL(string: team.icon ?? ""))
                    .resizable()
                    .placeholder {
                        Rectangle()
                            .foregroundColor(Color.black.opacity(0.1))
                            .frame(width: 32, height: 32)
                    }
                    .cacheOriginalImage()
                    .retry(maxCount: 3, interval: .seconds(5))
                    .fade(duration: 0.25)
                    .cancelOnDisappear(true)
                    .frame(width: 32, height: 32)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
                Text(team.name)
                    .padding(.leading, 12)
            }.padding(.vertical, 8)
        }
        
    }
    
}

struct MatchListCell_Previews: PreviewProvider {
    static var previews: some View {
        MatchListCell(match: Match.testMatch)
            .background(Color.gray.opacity(0.3))
    }
}

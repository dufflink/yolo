//
//  MatchStatusList.swift
//  Yolo
//
//  Created by Maxim Skorynin on 23.10.2022.
//

import SwiftUI

struct MatchStatusList: View {
    
    let mathStatuses: [Match.Status]
    let leagues: [LeagueListModel]
    
    @Binding var selectedStatus: Match.Status
    var tapOnTrophy: (() -> Void) = { }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(mathStatuses.reversed()) { mathStatus in
                    Text(mathStatus.title)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(selectedStatus == mathStatus ? (mathStatus == .running ? Color.red : Color.blue) : Color.gray)
                        .cornerRadius(20)
                        .onTapGesture {
                            selectedStatus = mathStatus
                        }
                }
                
                if leagues.count > 1 {
                    ZStack(alignment: .bottomTrailing) {
                        Circle()
                            .frame(width: 42, height: 41)
                            .foregroundColor(.yellow)
                            .overlay {
                                Image("Cup")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.black.opacity(0.7))
                            }
                        
                        let selectedCount = leagues.filter { $0.selected == true }.count

                        if selectedCount > 0 {
                            Text("\(selectedCount)")
                                .frame(width: 20, height: 20)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color.white)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 4)
                        }
                    }
                    .padding(.horizontal, 8)
                    .onTapGesture {
                        tapOnTrophy()
                    }
                }
                
            }
            .padding(.horizontal, 16)
        }
    }
}

struct MatchStatusList_Previews: PreviewProvider {
    static var previews: some View {
        MatchStatusList(mathStatuses: [
            .running, .notStarted, .finished
        ], leagues: [.init(name: "123", selected: true)], selectedStatus: .constant(.running))
    }
}

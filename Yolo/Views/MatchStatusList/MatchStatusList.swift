//
//  MatchStatusList.swift
//  Yolo
//
//  Created by Maxim Skorynin on 23.10.2022.
//

import SwiftUI

struct MatchStatusList: View {
    
    let mathStatuses: [Match.Status]
    
    @Binding var selectedStatus: Match.Status
    @Binding var events: [EventListModel]
    
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
                
                ZStack(alignment: .bottomTrailing) {
                    Image(systemName: "trophy.fill")
                        .opacity(0.8)
                        .frame(width: 41, height: 44)
                        .background(Color.yellow)
                        .foregroundColor(Color.black.opacity(0.8))
                        .clipShape(Circle())
                    
                    let selectedCount = events.filter { $0.selected == true }.count
                    
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
            .padding(.horizontal, 16)
        }
    }
}

struct MatchStatusList_Previews: PreviewProvider {
    static var previews: some View {
        MatchStatusList(mathStatuses: [
            .running, .notStarted, .finished
        ], selectedStatus: .constant(.running), events: .constant([
            .init(name: "", tier: 1, selected: true),
            .init(name: "", tier: 1, selected: false),
            .init(name: "", tier: 1, selected: false)
        ]))
    }
}

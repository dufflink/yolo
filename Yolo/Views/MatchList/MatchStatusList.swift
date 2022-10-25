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
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(mathStatuses.reversed()) { mathStatus in
                    Text(mathStatus.title)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(selectedStatus == mathStatus ? (mathStatus == .running ? Color.red : Color.blue) : Color.gray)
                        .cornerRadius(20)
                        .onTapGesture {
                            selectedStatus = mathStatus
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
        ], selectedStatus: .constant(.running))
    }
}

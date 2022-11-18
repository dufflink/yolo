//
//  EventList.swift
//  Yolo
//
//  Created by Maxim Skorynin on 10.11.2022.
//

import SwiftUI

struct Event: Identifiable {
    
    let id: UUID = .init()
    let name: String
    
}

struct EventListModel: Identifiable, Hashable {
    
    let id: UUID = .init()
    
    let name: String
    let tier: Int
    
    var selected: Bool
    
}

struct EventListCell: View {
    
    @Binding var event: EventListModel
    
    var didSelectAction: ((Bool) -> Void)? = nil
    
    var body: some View {
        HStack {
            Image(systemName: "trophy.fill")
                .foregroundColor(getTierColor(tier: event.tier))
            
            Text(event.name)
                .fontWeight(.medium)
            Spacer()
            
            Image(systemName: event.selected ? "circle.inset.filled" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color.blue)
        }
        .opacity(event.selected ? 1 : 0.4)
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture {
            event.selected.toggle()
            didSelectAction?(event.selected)
        }
    }
    
    func getTierColor(tier: Int) -> Color {
        if tier == 1 {
            return .yellow
        }
        
        return tier == 2 ? .gray : .brown
    }
    
}

struct EventList: View {
    
    @State private var initSelectedEvents: Set<UUID> = []
    @State private var selectedEvents: Set<UUID> = []
    
    @State private var internalState: [EventListModel] = []
    var events: [EventListModel] = []
    
    var didPressCloseButton: (() -> Void)?
    var didPressSaveButton: (([EventListModel]) -> Void)?
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack(spacing: 16) {
                Text("Tournaments")
                    .fontWeight(.bold)
                    .foregroundColor(Color.purple)
                Spacer()
                
                Button(action: {
                    updateState(with: internalState)
                    didPressSaveButton?(internalState)
                }, label: {
                    Text("Save")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(initSelectedEvents != selectedEvents ? Color.green : Color.gray.opacity(0.2))
                        .foregroundColor(Color.white)
                        .cornerRadius(18)
                })
                .disabled(initSelectedEvents == selectedEvents)
                
                Button(action: {
                    updateState(with: events)
                    didPressCloseButton?()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 34, height: 34)
                        .foregroundColor(Color.gray.opacity(0.5))
                })
            }.padding(.horizontal, 34)
            
            List(internalState.indices, id: \.self) { index in
                EventListCell(event: $internalState[index], didSelectAction: { selected in
                    let event = internalState[index]
                    
                    if selected {
                        selectedEvents.insert(event.id)
                    } else {
                        selectedEvents.remove(event.id)
                    }
                })
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .frame(maxHeight: events.count > 6 ? 300 : CGFloat(events.count) * 52)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
                .padding(.horizontal, 16)
                .padding(.vertical, -8)
                .shadow(color: Color.black.opacity(0.1), radius: 12, x: 2, y: 2)
        )
        .onAppear {
            updateState(with: events)
        }
    }
    
    func updateState(with events: [EventListModel]) {
        let selected = events.filter { $0.selected == true }.map { $0.id }
        internalState = events
        
        selectedEvents = Set(selected)
        initSelectedEvents = Set(selected)
    }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList(events: [
            .init(name: "ESL Pro league", tier: 1, selected: false),
            .init(name: "Blast", tier: 1, selected: true),
            .init(name: "DCL Pro league", tier: 2, selected: false),
            .init(name: "First arrow season XII", tier: 3, selected: true),
            .init(name: "IEM Rio", tier: 1, selected: true)
        ])
    }
}

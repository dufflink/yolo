//
//  MatchList.swift
//  Yolo
//
//  Created by Maxim Skorynin on 12.10.2022.
//

import SwiftUI

struct MatchListSection: Identifiable {
    
    let id: UUID = .init()
    
    let timeCategory: Match.Status
    let matches: [Match]
    
}

extension MatchList {
    
    func headerView<V: View>(@ViewBuilder _ view: () -> V) -> Self {
        var copy = self
        copy.headerView = AnyView(view())
        
        return copy
    }
    
}

struct MatchList: View {
    
    let matches: [Match]
    let bottomInset: CGFloat
    
    var headerView: AnyView? = nil
    
    @Binding var isLoading: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack {
                    if let headerView = headerView {
                        headerView
                    }
                    if isLoading {
                        let frame = geometry.frame(in: .global)
                        ProgressView()
                            .position(x: frame.midX, y: frame.midY - 180)
                    } else {
                        ForEach(matches) { match in
                            VStack(alignment: .trailing) {
                                MatchListCell(match: match)
                                Rectangle()
                                    .padding(.leading, 42)
                                    .foregroundColor(Color.black.opacity(0.1))
                                    .frame(height: 0.5)
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        Color.clear.padding(.bottom, bottomInset)
                    }
                }
            }
        }
    }
}

struct MatchList_Previews: PreviewProvider {
    static var previews: some View {
        MatchList(matches: [
            Match.testMatch,
            Match.testMatch,
            Match.testMatch,
            Match.testMatch,
            Match.testMatch,
            Match.testMatch,
            Match.testMatch,
            Match.testMatch,
            Match.testMatch
        ], bottomInset: 0, isLoading: .constant(false))
    }
}

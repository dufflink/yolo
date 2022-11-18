//
//  RounderTextModifier.swift
//  Yolo
//
//  Created by Maxim Skorynin on 25.10.2022.
//

import SwiftUI

struct RounderTextModifier: ViewModifier {
    
    let background: AnyView
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(Color.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(background)
            .cornerRadius(4)
    }
    
}

extension Text {
    
    func roundedText<Background>(background: Background) -> some View where Background: View {
        modifier(RounderTextModifier(background: AnyView(background)))
    }
    
}

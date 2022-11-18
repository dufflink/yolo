//
//  ButtonPress.swift
//  Yolo
//
//  Created by Maxim Skorynin on 31.10.2022.
//

import SwiftUI

struct ButtonPress: ViewModifier {
    
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content.simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ _ in
                    onPress()
                })
                .onEnded({ _ in
                    onRelease()
                })
        )
    }
    
}

struct ButtonLongPress: ViewModifier {
    
    var duration: Double = 0.0
    
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content.simultaneousGesture(
            LongPressGesture(minimumDuration: duration)
                .onChanged({ _ in
                    onPress()
                })
                .onEnded({ _ in
                    onRelease()
                })
        )
    }
    
}

extension View {
    
    func pressEvents(onPress: @escaping (() -> Void) = {}, onRelease: @escaping (() -> Void) = {}) -> some View {
        modifier(ButtonPress(onPress: { onPress() }, onRelease: { onRelease() }))
    }
    
    func longPressEvents(duration: Double, onPress: @escaping (() -> Void) = {}, onRelease: @escaping (() -> Void) = {}) -> some View {
        modifier(ButtonLongPress(duration: duration, onPress: { onPress() }, onRelease: { onRelease() }))
    }
    
}

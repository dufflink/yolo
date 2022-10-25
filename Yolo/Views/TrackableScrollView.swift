//
//  TrackableScrollView.swift
//  Yolo
//
//  Created by Maxim Skorynin on 23.10.2022.
//

import SwiftUI

struct ScrollOffsetKey: PreferenceKey {
    typealias Value = [CGFloat]
    
    static var defaultValue: [CGFloat] = [0]
    
    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}

struct TrackableScrollView<Content>: View where Content: View {
    
    let axes: Axis.Set
    let showIndicators: Bool
    @Binding var contentOffset: CGFloat
    let content: Content
    
    init(_ axes: Axis.Set = .vertical, showIndicators: Bool = true, contentOffset: Binding<CGFloat>, @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.showIndicators = showIndicators
        self._contentOffset = contentOffset
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { outsideProxy in
            ScrollView(axes, showsIndicators: showIndicators) {
                ZStack(alignment: axes == .vertical ? .top : .leading) {
                    GeometryReader { insideProxy in
                        Color.clear
                            .preference(key: ScrollOffsetKey.self, value: [calculateContentOffset(fromOutsideProxy: outsideProxy, insideProxy: insideProxy)])
                    }
                    VStack {
                        content
                    }
                }
            }.onPreferenceChange(ScrollOffsetKey.self) { value in
                contentOffset = value[0]
            }
        }
    }
    
    private func calculateContentOffset(fromOutsideProxy outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
        if axes == .vertical {
            return outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY
        } else {
            return outsideProxy.frame(in: .global).minX - insideProxy.frame(in: .global).minX
        }
    }
}

//
//  PagerView.swift
//  Snip
//
//  Created by Anthony Fernandez on 9/8/20.
//  Copyright © 2020 pictarine. All rights reserved.
//  FROM : https://swiftwithmajid.com/2019/12/25/building-pager-view-in-swiftui/

import SwiftUI

struct PagerView<Content: View>: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    let content: Content

    @GestureState private var translation: CGFloat = 0

    init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 0) {
                    self.content.frame(width: geometry.size.width)
                }
                .frame(width: geometry.size.width, alignment: .leading)
                .offset(x: -CGFloat(self.currentIndex) * geometry.size.width)
                .offset(x: self.translation)
                .animation(.interactiveSpring())
                .gesture(
                    DragGesture().updating(self.$translation) { value, state, _ in
                        state = value.translation.width
                    }.onEnded { value in
                        let offset = value.translation.width / geometry.size.width
                        let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                        self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
                    }
                )
                
                VStack {
                    Spacer()
                    
                    HStack {
                        ForEach(0..<self.pageCount, id: \.self) { index in
                            Circle()
                                .fill(index == self.currentIndex ? Color.white : Color.gray)
                                .frame(width: 10, height: 10)
                        }
                    }
                }
                .offset(y: 16)
            }
        }
    }
}

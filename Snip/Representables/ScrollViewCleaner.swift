//
//  ScrollViewCleaner.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/2/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import SwiftUI


// HACKY WAY TO HAD A COLOR TO A LIST FOR MACOS

struct ScrollViewCleaner: NSViewRepresentable {

    func makeNSView(context: NSViewRepresentableContext<ScrollViewCleaner>) -> NSView {
        let nsView = NSView()
        DispatchQueue.main.async { // on next event nsView will be in view hierarchy
            if let scrollView = nsView.enclosingScrollView {
                scrollView.drawsBackground = false
            }
        }
        return nsView
    }

    func updateNSView(_ nsView: NSView, context: NSViewRepresentableContext<ScrollViewCleaner>) {
    }
}

extension View {
    func removingScrollViewBackground() -> some View {
        self.background(ScrollViewCleaner())
    }
}

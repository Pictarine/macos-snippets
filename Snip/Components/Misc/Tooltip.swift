//
//  Tooltip.swift
//  Snip
//
//  Created by Anthony Fernandez on 11/2/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import SwiftUI


/**
 FROM: https://developer.apple.com/forums/thread/123243
 */
public extension View {
  /// Overlays this view with a view that provides a toolTip with the given string.
  func tooltip(_ toolTip: String?) -> some View {
    self.overlay(TooltipView(toolTip))
  }
}

private struct TooltipView: NSViewRepresentable {
  let toolTip: String?
  
  init(_ toolTip: String?) {
    self.toolTip = toolTip
  }
  
  func makeNSView(context: NSViewRepresentableContext<TooltipView>) -> NSView {
    let view = NSView()
    view.toolTip = self.toolTip
    return view
  }
  
  func updateNSView(_ nsView: NSView, context: NSViewRepresentableContext<TooltipView>) {
  }
}

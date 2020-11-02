//
//  Tooltip.swift
//  Snip
//
//  Created by Anthony Fernandez on 11/2/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import SwiftUI


extension View {
  func tooltip(_ tip: String) -> some View {
    background(GeometryReader { childGeometry in
      TooltipView(tip, geometry: childGeometry) {
        self
      }
    })
  }
}

private struct TooltipView<Content>: View where Content: View {
  let content: () -> Content
  let tip: String
  let geometry: GeometryProxy
  
  init(_ tip: String, geometry: GeometryProxy, @ViewBuilder content: @escaping () -> Content) {
    self.content = content
    self.tip = tip
    self.geometry = geometry
  }
  
  var body: some View {
    Tooltip(tip, content: content)
      .frame(width: geometry.size.width, height: geometry.size.height)
  }
}

private struct Tooltip<Content: View>: NSViewRepresentable {
  typealias NSViewType = NSHostingView<Content>
  
  init(_ text: String?, @ViewBuilder content: () -> Content) {
    self.text = text
    self.content = content()
  }
  
  let text: String?
  let content: Content
  
  func makeNSView(context _: Context) -> NSHostingView<Content> {
    NSViewType(rootView: content)
  }
  
  func updateNSView(_ nsView: NSHostingView<Content>, context _: Context) {
    nsView.rootView = content
    nsView.toolTip = text
  }
}


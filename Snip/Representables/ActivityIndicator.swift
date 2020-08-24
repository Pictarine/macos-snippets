//
//  ActivityIndicator.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/24/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import SwiftUI

struct ActivityIndicator: NSViewRepresentable {
  
  @Binding var isAnimating: Bool
  let style: NSProgressIndicator.Style
  
  func makeNSView(context: Context) -> NSProgressIndicator {
    let progress = NSProgressIndicator()
    progress.style = style
    return progress
  }
  
  func updateNSView(_ uiView: NSProgressIndicator, context: Context) {
    isAnimating ? uiView.startAnimation(nil) : uiView.stopAnimation(nil)
  }
}

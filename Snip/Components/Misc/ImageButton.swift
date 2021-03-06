//
//  ImageButton.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/30/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct ImageButton<Content: View>: View {
  
  @Environment(\.themeTextColor) var themeTextColor
  
  let imageName: String
  let action: () -> ()
  let content: () -> Content?
  
  var body: some View {
    Button(action: action) {
      Image(imageName)
        .resizable()
        .renderingMode(.original)
        .colorMultiply(themeTextColor)
        .scaledToFit()
        .frame(width: 20, height: 20, alignment: .center)
        .background(Color.transparent)
    }
    .background(content())
    .buttonStyle(PlainButtonStyle())
    .onHover { inside in
      if inside {
        NSCursor.pointingHand.push()
      } else {
        NSCursor.pop()
      }
    }
  }
}

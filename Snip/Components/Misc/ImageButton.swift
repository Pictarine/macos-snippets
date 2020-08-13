//
//  ImageButton.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/30/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct ImageButton<Content: View>: View {
  
  let imageName: String
  let action: () -> ()
  let content: () -> Content?
  
  var body: some View {
    Button(action: action) {
      Image(imageName)
        .resizable()
        .scaledToFit()
        .frame(width: 20, height: 20, alignment: .center)
    }
    .background(content())
    .buttonStyle(PlainButtonStyle())
  }
}

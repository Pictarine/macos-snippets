//
//  TagView.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/5/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct TagView: View {
  
  @State private var canRemoveTags = false
  var tag: String
  var onRemoveTapped: (() -> ())?
  
  var body: some View {
    VStack {
      Spacer()
      ZStack() {
        Text(tag)
          .frame(minWidth: 20, maxHeight: 18)
          .padding(4)
          .background(Color.transparent)
          .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.text.opacity(0.8), lineWidth: 1))
          .foregroundColor(Color.text.opacity(0.8))
          .overlay(closeOverlay, alignment: .topTrailing)
          .onHover { (hover) in
            withAnimation(.easeInOut(duration: 0.3)) {
              self.canRemoveTags = hover
            }
        }
        .zIndex(0)
        
      }
      
      Spacer()
    }
  }
  
  @ViewBuilder
  var closeOverlay: some View {
    if canRemoveTags {
      Image("ic_close")
        .resizable()
        .frame(width: 15, height: 15)
        .offset(x: 4, y: -4)
        .transition(.opacity)
        .onTapGesture {
          self.onRemoveTapped?()
      }
    }
  }
}


struct TagView_Previews: PreviewProvider {
  static var previews: some View {
    TagView(tag: "HelloTag")
  }
}

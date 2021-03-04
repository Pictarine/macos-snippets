//
//  SidebarTagView.swift
//  Snip
//
//  Created by Junior on 03/03/2021.
//  Copyright © 2021 pictarine. All rights reserved.
//

import SwiftUI

struct SidebarTagView<Content: View>: View {
  
  @ObservedObject var viewModel: SidebarTagViewModel
  
  @State private var isExpanded: Bool = false
  
  let content: () -> Content?
  
  var body: some View {
    Button(action: {
      isExpanded.toggle()
    }) {
      
      HStack {
        
        VStack {
          Spacer()
          Image( isExpanded ? "ic_up" : "ic_down")
            .resizable()
            .renderingMode(.original)
            .colorMultiply(Color.GREY_500)
            .scaledToFit()
            .frame(width: 10, height: 10, alignment: .center)
          Spacer()
        }
        .padding(.leading, 8)
        
        Text(viewModel.tag.capitalized)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color.transparent)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(0)
    .background(Color.transparent)
    .buttonStyle(PlainButtonStyle())
    .onHover { inside in
      if inside {
        NSCursor.pointingHand.push()
      } else {
        NSCursor.pop()
      }
    }
    
    if isExpanded {
      content()
    }
  }
}

final class SidebarTagViewModel: ObservableObject {
  
  var tag: String = ""
  
  init(tag: String) {
    self.tag = tag
  }
}

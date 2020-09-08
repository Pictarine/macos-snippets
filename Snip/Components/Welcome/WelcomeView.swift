//
//  WelcomeView.swift
//  Snip
//
//  Created by Anthony Fernandez on 9/8/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
  
  @ObservedObject var viewModel: WelcomeViewModel
  @State var currentPage = 0
  
  var body: some View {
    ZStack {
      
      backgroundView
      .frame(width: viewModel.size.width, height: viewModel.size.height)
      .transition(AnyTransition.opacity)
      
      VStack(alignment: .leading) {
        PagerView(pageCount: 3, currentIndex: $currentPage) {
            firstView
            secondView
        }
      }
      .frame(width: viewModel.size.width / 2.5,
             height: viewModel.size.height / 1.5,
             alignment: .center)
      .background(Color.secondary)
      .cornerRadius(4.0)
      .offset(x: 0,
              y: viewModel.isVisible ? ((viewModel.size.height / 2) - ((viewModel.size.height / 1.5) / 1.5)) : 10000)
      .transition(AnyTransition.move(edge: .bottom))
    }
  }
  
  var firstView: some View {
    VStack {
      Spacer()
      Text("Test 1")
      Spacer()
      HStack {
        Spacer()
        Button(action: {
          self.currentPage += 1
        }) {
          Text("Next")
          .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
          .background(Color.accent)
          .cornerRadius(4)
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
    .padding()
  }
  
  var secondView: some View {
    VStack {
      Spacer()
      Text("Test 2")
      Spacer()
    }
    .padding()
  }
  
  var backgroundView: some View {
    viewModel.isVisible ? Color.black.opacity(0.8) : Color.clear
  }
}

final class WelcomeViewModel: ObservableObject {
  
  var isVisible: Bool
  var size: CGSize
  
  init(isVisible: Bool, readerSize: CGSize) {
    self.isVisible = isVisible
    self.size = readerSize
  }
}

struct WelcomeView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeView(viewModel: WelcomeViewModel(isVisible: true,
                                            readerSize: CGSize(width: 300, height: 400)))
  }
}

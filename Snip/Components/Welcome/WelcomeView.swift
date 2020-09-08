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
  
  var body: some View {
    ZStack {
      
      backgroundView
      .frame(width: viewModel.size.width, height: viewModel.size.height)
      .transition(AnyTransition.opacity)
      
      VStack(alignment: .leading) {
        Text("zeijr")
      }
      .frame(width: viewModel.size.width / 2.5,
             height: viewModel.size.height / 1.5,
             alignment: .center)
      .padding()
      .background(Color.red)
      .cornerRadius(4.0)
      .offset(x: 0,
              y: viewModel.isVisible ? ((viewModel.size.height / 2) - ((viewModel.size.height / 1.5) / 1.5)) : 10000)
      .transition(AnyTransition.move(edge: .bottom))
    }
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

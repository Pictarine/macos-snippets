//
//  SettingsView.swift
//  Snip
//
//  Created by Anthony Fernandez on 9/7/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
  
  @ObservedObject var viewModel: SettingsViewModel
  @EnvironmentObject var settings: Settings
  
  var body: some View {
    ZStack {
      
      VStack(alignment: .leading) {
        Text("Hello")
      }
      .frame(width: viewModel.size.width / 2.5,
             height: viewModel.size.height / 1.5,
             alignment: .center)
      .background(Color.primary)
      .cornerRadius(4.0)
      .offset(x: 0,
              y: settings.isSettingsOpened ? (( viewModel.size.height / 2) - ((viewModel.size.height / 1.5) / 1.5)) : 10000)
      .transition(AnyTransition.move(edge: .bottom))
      
    }
  }
}

final class SettingsViewModel: ObservableObject {
  
  var size: CGSize
  
  
  init(readerSize: CGSize) {
    self.size = readerSize
  }
  
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView(viewModel: SettingsViewModel(readerSize: CGSize(width: 400,
                                                                 height: 300)))
  }
}

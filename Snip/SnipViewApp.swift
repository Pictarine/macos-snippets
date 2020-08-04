//
//  ContentView.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct SnipViewApp: View {
  
  var body: some View {
    appNavigation
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  @ViewBuilder
  var appNavigation: some View {
    NavigationView {
      Sidebar(viewModel: SideBarViewModel(snippets: SnipItem.preview()))
        .visualEffect(material: .sidebar)
        .frame(minWidth: 180, idealWidth: 200, maxWidth: 240)
      EmptyView()
    }
    .edgesIgnoringSafeArea(.top)
  }
}


struct SnipViewApp_Previews: PreviewProvider {
  static var previews: some View {
    SnipViewApp()
  }
}

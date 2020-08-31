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
      
      sideBar
      openingPanel
    }
    .edgesIgnoringSafeArea(.top)
  }
  
  var sideBar: some View {
    Sidebar(viewModel: SideBarViewModel())
      //.visualEffect(material: .sidebar)
      .background(Color.secondary)
      .frame(minWidth: 0, idealWidth: 200, maxWidth: 240)
  }
  
  var openingPanel: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        Text("Create your first Snipppet")
          .font(Font.custom("HelveticaNeue-Light", size: 20))
          .foregroundColor(Color.text)
        Spacer()
      }
      HStack {
        Spacer()
        Text("Tips: Cmd+F to search words and regex")
          .font(Font.custom("HelveticaNeue-Light", size: 16))
          .foregroundColor(Color.text)
        Spacer()
      }
      .padding(.top, 8)
      Spacer()
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    .background(Color.primary)
  }
}


struct SnipViewApp_Previews: PreviewProvider {
  static var previews: some View {
    SnipViewApp()
  }
}

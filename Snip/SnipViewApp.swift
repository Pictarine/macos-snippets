//
//  ContentView.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct SnipViewApp: View {
  
  @ObservedObject var syncManager = SyncManager.shared
  @EnvironmentObject var settings: Settings
  
  var body: some View {
    appNavigation
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  @ViewBuilder
  var appNavigation: some View {
    GeometryReader { reader in
      ZStack {
        NavigationView {
          
          self.sideBar
          self.openingPanel
        }
        self.settingPanel
          .frame(width: reader.size.width, height: reader.size.height)
      }
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
  
  var settingPanel: some View {
    GeometryReader { reader in
      ZStack {
        
        VStack {
          Text("Hello")
        }
        .frame(width: reader.size.width / 2.5, height: reader.size.height, alignment: .center)
        .background(Color.BLACK_500)
        .offset(x: 0, y: self.settings.isSettingsOpened ? 120 : 10000)
        .transition(AnyTransition.move(edge: .bottom))
        
      }
    }
    .background(self.settings.isSettingsOpened ? Color.RED_500.opacity(0.6) : Color.clear)
    .transition(AnyTransition.opacity)
  }
}


struct SnipViewApp_Previews: PreviewProvider {
  static var previews: some View {
    SnipViewApp()
  }
}

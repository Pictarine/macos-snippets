//
//  Sidebar.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct Sidebar: View {
  
  @ObservedObject var viewModel: SideBarViewModel
  
  var body: some View {
    VStack(alignment: .leading) {
      List() {
        
        addElementView
        
        logo
        
        favorites
        
        local
        
        //tags
      }
      .removeBackground()
      .padding(.top, 8)
      .background(Color.clear)
      
      HStack {
        Spacer()
        
        ImageButton(imageName: "ic_settings", action: settings)
      }
      .padding()
    }
    .background(Color.clear)
    .listRowBackground(Color.PURPLE_500)
      //.listStyle(SidebarListStyle())
      .environment(\.defaultMinListRowHeight, 36)
  }
  
  var addElementView: some View {
    HStack{
      Spacer()
      Button(action: test) {
        Text("+")
          .font(.system(size: 20))
      }
      .background(Color.clear)
      .buttonStyle(PlainButtonStyle())
    }.background(Color.clear)
  }
  
  var logo: some View {
    HStack(alignment: .center) {
      Spacer()
      Image("snip")
        .resizable()
        .frame(width: 30, height: 30, alignment: .center)
      Spacer()
    }
    .padding(.top, 16)
    .padding(.bottom, 16)
  }
  
  @ViewBuilder
  var favorites: some View {
    Text("Favorites")
      .font(Font.custom("AppleSDGothicNeo-UltraLight", size: 11.0))
      .padding(.bottom, 3)
    
    SnipItemsList(snipItems: viewModel.snips)
  }
  
  @ViewBuilder
  var local: some View {
    Text("Local")
      .font(Font.custom("AppleSDGothicNeo-UltraLight", size: 11.0))
      .padding(.bottom, 3)
      .padding(.top, 16)
  }
  
  /*@ViewBuilder
  var tags: some View {
    Text("Tags")
      .font(Font.custom("AppleSDGothicNeo-UltraLight", size: 11.0))
      .padding(.bottom, 3)
      .padding(.top, 16)
    
    NavigationLink(destination: CodeViewer()) {
      Text("Hello")
        .frame(maxWidth: .infinity, alignment: .leading)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
    .listRowBackground(Color.PURPLE_500)
  }*/
  
  
  func test() {
    print("Test")
  }
  
  func settings() {
    print("settings")
  }
}


final class SideBarViewModel: ObservableObject {
  
  @Published var snips: [SnipItem] = []
  
  init(snippets: [SnipItem]) {
    snips = snippets
  }
}


struct Sidebar_Previews: PreviewProvider {
  static var previews: some View {
    Sidebar(viewModel: SideBarViewModel(snippets: SnipItem.preview()))
  }
}

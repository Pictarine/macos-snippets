//
//  Sidebar.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct Sidebar: View {
  private let snips: [SnipItem] = SnipItem.preview()
  
  @State private var selection: String?
  
  var body: some View {
    VStack(alignment: .leading) {
      List() {
        
        HStack{
          Spacer()
          Button(action: test) {
            Text("+")
              .font(.system(size: 20))
          }
          .background(Color.clear)
          .buttonStyle(PlainButtonStyle())
        }.background(Color.clear)
        
        HStack(alignment: .center) {
          Spacer()
          Image("snip")
            .resizable()
            .frame(width: 30, height: 30, alignment: .center)
          Spacer()
        }
        .padding(.top, 16)
        .padding(.bottom, 16)
        
        Text("Favorites")
          .font(Font.custom("AppleSDGothicNeo-UltraLight", size: 11.0))
          .padding(.bottom, 3)
        
        SnipItemsList(snipItems: snips)
        
        Text("Local")
          .font(Font.custom("AppleSDGothicNeo-UltraLight", size: 11.0))
          .padding(.bottom, 3)
          .padding(.top, 16)
        
        Text("Tags")
          .font(Font.custom("AppleSDGothicNeo-UltraLight", size: 11.0))
          .padding(.bottom, 3)
          .padding(.top, 16)
      }
      .removeBackground()
      .padding(.top, 1)
      .background(Color.clear)
      
      HStack {
        Spacer()
        
        ImageButton(imageName: "ic_settings", action: settings)
      }
      .padding()
    }
    .background(Color.clear)
    //.listStyle(SidebarListStyle())
    //.listRowBackground(Color.PURPLE_500)
  }
  
  
  
  func test() {
    print("Test")
  }
  
  func settings() {
    print("settings")
  }
}



struct Sidebar_Previews: PreviewProvider {
  static var previews: some View {
    Sidebar()
  }
}

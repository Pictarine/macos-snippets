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
        }
        
        HStack(alignment: .center) {
          Spacer()
          Image("snip")
          .resizable()
          .frame(width: 30, height: 30, alignment: .center)
          Spacer()
        }
        .padding(.top, 16)
        .padding(.bottom, 16)
        
        Section(header: Text("Favorites").padding(.bottom, 3)) {
          SnipItemsList(snipItems: snips)
        }
        
        Section(header: Text("Local").padding(.bottom, 3)) {
          Text("OK")
        }
        //.padding(.top, 16)
        
        Section(header: Text("Tags").padding(.bottom, 3)) {
          NavigationLink(destination: CodeViewer()) {
            Text("Quick")
          }
        }
        .padding(.top, 16)
      }
      .padding(.top, 1)
      //.background(Color.BLACK_200)
      
    }
    .listStyle(SidebarListStyle())
    //.listRowBackground(Color.PURPLE_500)
  }
  
  
}

func test() {
  print("Test")
}

struct Sidebar_Previews: PreviewProvider {
  static var previews: some View {
    Sidebar()
  }
}

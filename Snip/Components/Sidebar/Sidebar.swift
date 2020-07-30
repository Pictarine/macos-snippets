//
//  Sidebar.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct Sidebar: View {
  private let names = ["Homer", "Marge", "Bart", "Lisa"]
  @State private var selection: String?
  
  var body: some View {
    VStack(alignment: .leading) {
      List(selection: $selection) {
        
        HStack{
          Spacer()
          Button(action: test) {
            Text("+")
              .font(.system(size: 20))
          }
          .background(Color.clear)
          .buttonStyle(PlainButtonStyle())
        }
        
        Section(header: Text("Favorites")) {
          ForEach(names, id: \.self) { name in
            NavigationLink(destination: CodeViewer()) {
              Text(name)
            }
          }
        }
        
        Section(header: Text("Local")) {
          NavigationLink(destination: CodeViewer()) {
            Text("VC Objc-C")
          }
        }
        .padding(.top, 16)
        
        Section(header: Text("Tags")) {
          NavigationLink(destination: CodeViewer()) {
            Text("Quick")
          }
        }
        .padding(.top, 16)
      }
      .padding(.top, 1)
      .background(Color.BLACK_200)
      
    }
    .listStyle(SidebarListStyle())
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

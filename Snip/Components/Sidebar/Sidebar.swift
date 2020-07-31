//
//  Sidebar.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct Sidebar: View {
  private let names = [
    SnipItem(name: "Hello", kind: .folder, content: [], tags: [], creationDate: Date(), lastUpdateDate: Date()),
    SnipItem(name: "IM", kind: .folder, content: [
      SnipItem(name: "Folder #1", kind: .folder, content: [
        SnipItem(name: "File #1", kind: .file, content: [], tags: [], creationDate: Date(), lastUpdateDate: Date())
      ], tags: [], creationDate: Date(), lastUpdateDate: Date())
    ], tags: [], creationDate: Date(), lastUpdateDate: Date()),
    SnipItem(name: "BATMAN", kind: .folder, content: [], tags: [], creationDate: Date(), lastUpdateDate: Date())
  ]
  
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
        
        Section(header: Text("Favorites")) {
          HierarchyList(data: names, children: \.content, rowContent: { Text($0.name) })
        }
        
        Section(header: Text("Local")) {
          HierarchyList(data: names, children: \.content, rowContent: { Text($0.name) })
        }
        //.padding(.top, 16)
        
        Section(header: Text("Tags")) {
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

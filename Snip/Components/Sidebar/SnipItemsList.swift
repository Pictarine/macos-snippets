//
//  SnipItemsList.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/31/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct SnipItemsList: View {
  
  let snipItems: [SnipItem]?
  
  var body: some View {
    ForEach(snipItems ?? [], id: \.id) { snip in
      
      Group {
        if self.containsSub(snip) {
          SnipItemView(snipItem: snip, content: { SnipItemsList(snipItems: snip.content).padding(.leading) })
        }
        else {
          SnipItemView(snipItem: snip, content: { EmptyView() })
        }
      }
      
    }.onMove(perform: move)
  }
  
  func containsSub(_ element: SnipItem) -> Bool {
    element.content != nil && element.content?.count ?? 0 > 0
  }
  
  func move(from source: IndexSet, to destination: Int) {
    print("Move from \(source) to \(destination)")
  }
}


struct SnipItemView<Content: View>: View {
  
  @State var isExpanded: Bool = false
  
  let snipItem: SnipItem
  let content: () -> Content?
  
  @ViewBuilder
  var body: some View {
    
    if snipItem.kind == .folder {
      
      Button(action: {
        self.isExpanded.toggle()
      },
             label: {
              HStack {
                Image( self.isExpanded ? "ic_up" : "ic_down")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 15, height: 15, alignment: .center)
                
                Image( self.isExpanded ? "ic_folder_opened" : "ic_folder_closed")
                  .resizable()
                  .frame(width: 15, height: 15, alignment: .center)
                Text(snipItem.name)
              }
                
              .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
              .background(Color.clear)
              .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
      })
        
        //.background(Color.red)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(0)
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(action: {
            }) {
              Text("Add folder")
            }
            
            Button(action: {
            }) {
              Text("Add snippet")
            }
            
            Button(action: {
            }) {
              Text("Delete")
            }
        }
      
    }
    else {
      NavigationLink(destination: CodeViewer()) {
        HStack {
          Image("ic_file")
            .resizable()
            .frame(width: 15, height: 15, alignment: .center)
            .padding(.leading, 4)
          Text(snipItem.name)
            .padding(.leading, 4)
          Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
      }
      .listRowBackground(Color.PURPLE_500)
      
    }
    
    
    
    if isExpanded {
      content()
    }
  }
  
}


struct SnipItemsList_Previews: PreviewProvider {
  static var previews: some View {
    return SnipItemsList(snipItems: SnipItem.preview())
  }
}

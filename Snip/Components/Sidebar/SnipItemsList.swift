//
//  SnipItemsList.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/31/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct SnipItemsList: View {
  
  @State var selection : UUID? = nil
  
  let snipItems: [SnipItem]?
  let onMove: (_ from: IndexSet, _ to: Int) -> Void
  let onActionTrigger: (SnipItemsListAction) -> Void
  
  var body: some View {
    ForEach(snipItems ?? [], id: \.id) { snip in
      
      Group {
        if self.containsSub(snip) {
          SnipItemView(snipItem: snip,
                       content: { SnipItemsList(snipItems: snip.content,
                                                onMove: self.onMove,
                                                onActionTrigger: self.onActionTrigger)
                        .padding(.leading)
          },
                       onActionTrigger: self.onActionTrigger,
                       selection: self.$selection
          )
        }
        else {
          SnipItemView(snipItem: snip,
                       content: { EmptyView() },
                       onActionTrigger: self.onActionTrigger,
                       selection: self.$selection
          )
        }
      }
      
    }//.onMove(perform: onMove)
  }
  
  func containsSub(_ element: SnipItem) -> Bool {
    element.content != nil && element.content?.count ?? 0 > 0
  }
  
}


struct SnipItemView<Content: View>: View {
  
  @State var isExpanded: Bool = false
  
  let snipItem: SnipItem
  let content: () -> Content?
  
  let onActionTrigger: (SnipItemsListAction) -> Void
  
  @Binding var selection: UUID?
  
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
                  
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.black.opacity(0.0001))
              }
                
              .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
              .background(Color.clear)
              .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
      })
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(0)
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
          Button(action: { self.onActionTrigger(.addFolder(id: self.snipItem.id)) }) {
            Text("Add folder")
          }
          
          Button(action: { self.onActionTrigger(.addSnippet(id: self.snipItem.id)) }) {
            Text("Add snippet")
          }
          
          Button(action: { self.onActionTrigger(.rename(id: self.snipItem.id)) }) {
            Text("Rename")
          }
          
          Button(action: { self.onActionTrigger(.delete(id: self.snipItem.id)) }) {
            Text("Delete")
          }
      }
      
    }
    else {
      NavigationLink(destination: CodeViewer(viewModel: CodeViewerViewModel(snipItem: snipItem)), tag: snipItem.id, selection: self.$selection) {
        HStack {
          Image("ic_file")
            .resizable()
            .frame(width: 15, height: 15, alignment: .center)
            .padding(.leading, 4)
          Text(snipItem.name)
            .padding(.leading, 4)
          .frame(maxWidth: .infinity, alignment: .leading)
          .background(Color.black.opacity(0.0001))
          Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
      }
      .contextMenu {
        Button(action: {
          self.onActionTrigger(.rename(id: self.snipItem.id))
          self.selection = self.snipItem.id
        }) {
          Text("Rename")
        }
        
        Button(action: {
          self.onActionTrigger(.delete(id: self.snipItem.id))
          self.selection = self.snipItem.id
        }) {
          Text("Delete")
        }
      }
      .listRowBackground(self.selection == self.snipItem.id ? Color.PURPLE_500 : Color.clear)
      
    }
    
    if isExpanded {
      content()
    }
  }
  
}


struct SnipItemsList_Previews: PreviewProvider {
  static var previews: some View {
    return SnipItemsList(snipItems: SnipItem.preview(),
                         onMove: { (from, to) in
                          print("onMove")
    },
                         onActionTrigger: { action in
                          print("action : \(action)")
    })
  }
}

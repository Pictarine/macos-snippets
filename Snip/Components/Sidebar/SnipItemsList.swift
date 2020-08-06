//
//  SnipItemsList.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/31/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI
import Combine


struct SnipItemsList: View {
  
  @EnvironmentObject var snippetsStore: SnippetStore
  
  @State var selection : String? = nil
  @ObservedObject var model: SnipItemsListModel
  
  let onMove: (_ from: IndexSet, _ to: Int) -> Void
  let onActionTrigger: (SnipItemsListAction) -> Void
  
  var body: some View {
    ForEach(snippetsStore.snipItems, id: \.id) { snipItem in
      
      Group {
        if self.containsSub(snipItem) {
          
          SnipItemView(viewModel: SnipItemViewModel(snip: snipItem,
                                                    selectedItem: self.$selection,
                                                    onAction: self.onActionTrigger),
                       content: {
                        
                        SnipItemsList(model: SnipItemsListModel(),
                                      onMove: self.onMove,
                                      onActionTrigger: self.onActionTrigger
                        )
                          .environmentObject(SnippetStore(snippets: snipItem.content ?? []))
                          .padding(.leading)
                        
          }
          )
          
        }
        else {
          
          SnipItemView(viewModel: SnipItemViewModel(snip: snipItem,
                                                    selectedItem: self.$selection,
                                                    onAction: self.onActionTrigger),
                       content: { EmptyView() })
          
        }
      }
      
    }//.onMove(perform: onMove)
  }
  
  func containsSub(_ element: SnipItem) -> Bool {
    element.content != nil && element.content?.count ?? 0 > 0
  }
  
}


class SnipItemsListModel: ObservableObject {
  
  init() {
    
  }
}


/*struct SnipItemsList_Previews: PreviewProvider {
 static var previews: some View {
 return SnipItemsList(model: SnipItemsListModel(snipItems: SnipItem.preview()),
 onMove: { (from, to) in
 print("onMove")
 },
 onActionTrigger: { action in
 print("action : \(action)")
 })
 }
 }
 */

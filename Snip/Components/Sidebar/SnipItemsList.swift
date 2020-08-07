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
  
  @ObservedObject var viewModel: SnipItemsListModel
  
  @State var selection : String? = nil
  
  var body: some View {
    ForEach(filterSnippets, id: \.id) { snipItem in
      
      Group {
        if self.containsSub(snipItem) {
          SnipItemView(viewModel: SnipItemViewModel(snip: snipItem,
                                                    selectedItem: self.$selection,
                                                    onTrigger: self.viewModel.onTrigger),
                       content: {
                        SnipItemsList(viewModel: SnipItemsListModel(snips: snipItem.content,
                                                                    applyFilter: self.viewModel.filter,
                                                                    onTrigger: self.viewModel.onTrigger))
                          .padding(.leading)
          }
          )
          
        }
        else {
          SnipItemView(viewModel: SnipItemViewModel(snip: snipItem,
                                                    selectedItem: self.$selection,
                                                    onTrigger: self.viewModel.onTrigger),
                       content: { EmptyView() })
        }
      }
      
    }
  }
  
  func containsSub(_ element: SnipItem) -> Bool {
    element.content.count > 0
  }
  
  var filterSnippets : [SnipItem] {
    switch viewModel.filter {
    case .all:
      return viewModel.snipItems
    case .favorites:
      return viewModel.snipItems.allFavorites
      
    }
  }
}


final class SnipItemsListModel: ObservableObject {
  
  @Published var snipItems: [SnipItem]
  
  enum ModelFilters {
    case all
    case favorites
  }
  
  var filter : ModelFilters = .all
  
  var onTrigger: (SnipItemsListAction) -> Void
  
  init(snips: [SnipItem], applyFilter: ModelFilters, onTrigger: @escaping (SnipItemsListAction) -> Void) {
    self.filter = applyFilter
    self.snipItems = snips
    self.onTrigger = onTrigger
  }
}


struct SnipItemsList_Previews: PreviewProvider {
  
  static var previews: some View {
    return SnipItemsList(viewModel: SnipItemsListModel(snips: Preview.snipItems,
                                                       applyFilter: .all,
                                                       onTrigger: { action in
                                                        print("action : \(action)")
    }))
  }
}


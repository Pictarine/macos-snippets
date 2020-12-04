//
//  SnipItemsList.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/31/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI


struct SnipItemsList: View {
  
  @ObservedObject var viewModel: SnipItemsListModel
  
  var body: some View {
    ForEach(viewModel.filterSnippets, id: \.id) { snipItem in
      
      Group {
        if viewModel.containsSub(snipItem) {
          SnipItemView(viewModel: SnipItemViewModel(snip: snipItem,
                                                    activeFilter: viewModel.filter,
                                                    onTrigger: viewModel.onTrigger,
                                                    onSnippetSelection: viewModel.onSnippetSelection),
                       content: {
                        SnipItemsList(viewModel: SnipItemsListModel(snips: snipItem.content,
                                                                    applyFilter: viewModel.filter,
                                                                    onTrigger: viewModel.onTrigger,
                                                                    onSnippetSelection: viewModel.onSnippetSelection))
                          .padding(.leading, 26)
                       }
          )
          
        }
        else {
          SnipItemView(viewModel: SnipItemViewModel(snip: snipItem,
                                                    activeFilter: viewModel.filter,
                                                    onTrigger: viewModel.onTrigger,
                                                    onSnippetSelection: viewModel.onSnippetSelection),
                       content: { EmptyView() })
        }
      }
      
    }
  }
  
  
}


final class SnipItemsListModel: ObservableObject {
  
  @Published var snipItems: [SnipItem]
  
  var filter : ModelFilter = .all
  
  var onTrigger: (SnipItemsListAction) -> Void
  var onSnippetSelection: (SnipItem, ModelFilter) -> Void
  
  init(snips: [SnipItem],
       applyFilter: ModelFilter,
       onTrigger: @escaping (SnipItemsListAction) -> Void,
       onSnippetSelection: @escaping (SnipItem, ModelFilter) -> Void) {
    self.filter = applyFilter
    self.snipItems = snips
    self.onTrigger = onTrigger
    self.onSnippetSelection = onSnippetSelection
  }
  
  var filterSnippets: [SnipItem] {
    switch filter {
    case .all:
      return snipItems
    case .favorites:
      return snipItems.allFavorites
    case .tag(let tagTitle):
      return snipItems.perTag(tag: tagTitle)
    }
  }
  
  func containsSub(_ element: SnipItem) -> Bool {
    return element.content.count > 0
  }
  
}



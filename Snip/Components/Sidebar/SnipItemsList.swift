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
  
  var body: some View {
    
    ForEach(viewModel.models, id: \.snipItem.id) { model in
      
      if viewModel.containsSub(model.snipItem) {
        SnipItemView(viewModel: model, content: {
          SnipItemsList(viewModel: SnipItemsListModel(snips: Just(model.snipItem.content).eraseToAnyPublisher(),
                                                      applyFilter: viewModel.filter,
                                                      onTrigger: viewModel.onTrigger,
                                                      onSnippetSelection: viewModel.onSnippetSelection))
        })
      }
      else {
        SnipItemView(viewModel: model, content: { EmptyView() })
      }
    }
    
  }
}


final class SnipItemsListModel: ObservableObject {
  
  @Published var models: [SnipItemViewModel] = []
  
  var filter : ModelFilter = .all
  
  var onTrigger: (SnipItemsListAction) -> Void
  var onSnippetSelection: (SnipItem, ModelFilter) -> Void
  
  var cancellable: AnyCancellable?
  
  init(snips: AnyPublisher<[SnipItem], Never>,
       applyFilter: ModelFilter,
       onTrigger: @escaping (SnipItemsListAction) -> Void,
       onSnippetSelection: @escaping (SnipItem, ModelFilter) -> Void) {
    
    self.filter = applyFilter
    self.onTrigger = onTrigger
    self.onSnippetSelection = onSnippetSelection
    
    cancellable = snips
      .sink { [weak self] (snippets) in
        guard let this = self else { return }
        
        this.models.removeAll()
        this.filterSnippets(snipItems: snippets, filter: applyFilter).forEach { (item) in
          let model = SnipItemViewModel(snip: item,
                                        activeFilter: applyFilter,
                                        onTrigger: onTrigger,
                                        onSnippetSelection: onSnippetSelection)
          
          this.models.append(model)
        }
        
      }
  }
  
  deinit {
    cancellable?.cancel()
  }
  
  func filterSnippets(snipItems: [SnipItem], filter: ModelFilter) -> [SnipItem] {
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



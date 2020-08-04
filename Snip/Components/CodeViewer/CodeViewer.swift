//
//  CodeViewer.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct CodeViewer: View {
  
  @ObservedObject var viewModel: CodeViewerViewModel
  
  @ViewBuilder
  var body: some View {
    VStack(alignment: .leading) {
      
      CodeActionsTopBar(viewModel: CodeActionsViewModel(name: $viewModel.snip.name,
                                                        isFavorite: $viewModel.snip.isFavorite))
      
      ModeSelectionView(viewModel: ModeSelectionViewModel(snippetMode: $viewModel.snip.mode,
                                                          snippetTags: $viewModel.snip.tags))
      
      CodeView(code: $viewModel.snip.snippet,
               mode: $viewModel.snip.mode,
               onContentChange: { content in
                self.viewModel.snip.snippet = content
                self.viewModel.snip.name = "Hello"
                self.viewModel.objectWillChange.send()
      })
        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
      
      Divider()
      
      CodeDetailsBottomBar(viewModel: CodeDetailsViewModel(snippetCode: self.$viewModel.snip.snippet))
      
    }
      
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    .background(Color.BLACK_500)
    .listStyle(PlainListStyle())
  }
  
}

final class CodeViewerViewModel: ObservableObject {
  
  @Published var snip: SnipItem
  
  init(snipItem: SnipItem) {
    self.snip = snipItem
  }
  
}


struct CodeViewer_Previews: PreviewProvider {
  static var previews: some View {
    CodeViewer(viewModel: CodeViewerViewModel(snipItem: SnipItem.previewSnipItem))
  }
}

//
//  CodeViewer.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct CodeViewer: View {
  
  @ObservedObject var viewModel: SnipItem
  
  @ViewBuilder
  var body: some View {
    VStack(alignment: .leading) {
      
      CodeActionsTopBar(viewModel: CodeActionsViewModel(id: viewModel.id,
                                                        name: viewModel.name,
                                                        isFavorite: viewModel.isFavorite))
      
      ModeSelectionView(currentMode: $viewModel.mode,
                        tags: $viewModel.tags)
      
      CodeView(code: $viewModel.snippet,
               mode: $viewModel.mode,
               onContentChange: { content in
                self.viewModel.snippet = content
      })
        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
      
      Divider()
      
      CodeDetailsBottomBar(viewModel: CodeDetailsViewModel(),
                           code: viewModel.snippet
      )
    }
      
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    .background(Color.BLACK_500)
    .listStyle(PlainListStyle())
  }
  
}


struct CodeViewer_Previews: PreviewProvider {
  static var previews: some View {
    CodeViewer(viewModel: SnipItem.previewSnipItem)
  }
}

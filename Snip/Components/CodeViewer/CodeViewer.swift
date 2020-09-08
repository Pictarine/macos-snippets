//
//  CodeViewer.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI
import Combine

struct CodeViewer: View {
  
  @ObservedObject var viewModel: CodeViewerViewModel
  @EnvironmentObject var appState: AppState
  @EnvironmentObject var snipItem: SnipItem
  
  @State private var shouldShowPreview = false
  
  var body: some View {
    
    VStack(alignment: .leading) {
      if appState.selectedSnippetId != nil {
        CodeActionsTopBar(viewModel: CodeActionsViewModel(name: snipItem.name,
                                                          code: snipItem.snippet,
                                                          isFavorite: snipItem.isFavorite,
                                                          lastUpdate: snipItem.lastUpdateDate,
                                                          syncState: snipItem.syncState ?? .local,
                                                          remoteURL: snipItem.remoteURL,
                                                          onRename: { name in
                                                            self.viewModel.onTrigger(.rename(id: self.snipItem.id, name: name))
        },
                                                          onToggleFavorite: {
                                                            self.viewModel.onTrigger(.toggleFavorite(id: self.snipItem.id))
        },
                                                          onDelete: {
                                                            self.viewModel.onTrigger(.delete(id: self.snipItem.id))
                                                            self.viewModel.onDimiss()
        },
                                                          onUpload: {
                                                            self.viewModel.onTrigger(.createGist(id: self.snipItem.id))
        },
                                                          onPreviewToggle: self.snipItem.mode == CodeMode.html.mode() || self.snipItem.mode == CodeMode.markdown.mode() ? {
                                                            withAnimation(Animation.easeOut(duration: 0.6)) { () -> () in
                                                              self.shouldShowPreview.toggle()
                                                            }
          } : nil
        ))
        
        ModeSelectionView(viewModel: ModeSelectionViewModel(snippetMode: snipItem.mode,
                                                            snippetTags: snipItem.tags,
                                                            onModeSelection: { mode in
                                                              self.viewModel.onTrigger(.updateMode(id: self.snipItem.id,
                                                                                                   mode: mode))
        },
                                                            onTagChange: { tag, job in
                                                              self.viewModel.onTrigger(.updateTags(id: self.snipItem.id,
                                                                                                   job: job,
                                                                                                   tag: tag))
        }))
        
        CodeView(code: .constant(self.snipItem.snippet),
                 mode: .constant(self.snipItem.mode),
                 onContentChange: { newCode in
                  self.viewModel.onTrigger(.updateCode(id: self.snipItem.id, code: newCode))
        })
          .frame(minWidth: 100,
                 maxWidth: .infinity,
                 minHeight: 100,
                 maxHeight: .infinity)
          .overlay(
            MarkdownHTMLViewer(code: self.snipItem.snippet, mode: self.snipItem.mode)
            .frame(minWidth: 100,
                   maxWidth: .infinity,
                   minHeight: 100,
                   maxHeight: .infinity)
              .background(Color.GREY_200)
              .offset(x: self.shouldShowPreview ? 0 : 10000, y: 0)
              .transition(AnyTransition.move(edge: .trailing)), alignment: .topLeading)
        
        
        Divider()
        
        CodeDetailsBottomBar(viewModel: CodeDetailsViewModel(snippetCode: self.snipItem.snippet))
      }
      else {
        Spacer()
        HStack {
          Spacer()
          Text("Snippet Successfully deleted")
            .font(Font.custom("HelveticaNeue-Light", size: 20))
            .foregroundColor(.text)
          Spacer()
        }
        HStack {
          Spacer()
          Text("Tips: Connect Snip to your GitHub account and save your snippet on Gist.")
            .font(Font.custom("HelveticaNeue-Light", size: 16))
            .foregroundColor(.text)
          Spacer()
        }
        .padding(.top, 8)
        Spacer()
      }
    }
    .frame(minWidth: 0,
           maxWidth: .infinity,
           minHeight: 0,
           maxHeight: .infinity,
           alignment: .topLeading)
      .background(Color.primary)
      .listStyle(PlainListStyle())
    
  }
  
}

class CodeViewerViewModel: ObservableObject {
  
  var onTrigger: (SnipItemsListAction) -> Void
  var onDimiss: () -> Void
  
  init(onTrigger: @escaping (SnipItemsListAction) -> Void,
       onDimiss: @escaping () -> Void) {
    self.onTrigger = onTrigger
    self.onDimiss = onDimiss
  }
  
}

struct CodeViewer_Previews: PreviewProvider {
  static var previews: some View {
    CodeViewer(viewModel: CodeViewerViewModel(onTrigger: { _ in
      print("action")
    },
                                              onDimiss:  { print("onDismiss")}
    ))
      .environmentObject(Preview.snipItem)
  }
}


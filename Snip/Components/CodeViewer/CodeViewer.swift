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
  
  @EnvironmentObject var settings: Settings
  
  @Environment(\.themeTextColor) var themeTextColor
  @Environment(\.themePrimaryColor) var themePrimaryColor
  
  @State private var shouldShowPreview = false
  
  var body: some View {
    
    VStack(alignment: .leading) {
      CodeActionsTopBar(viewModel: CodeActionsViewModel(name: viewModel.snipItem.name,
                                                        code: viewModel.snipItem.snippet,
                                                        isFavorite: viewModel.snipItem.isFavorite,
                                                        lastUpdate: viewModel.snipItem.lastUpdateDate,
                                                        syncState: viewModel.snipItem.syncState ?? .local,
                                                        remoteURL: viewModel.snipItem.remoteURL,
                                                        onRename: { name in
                                                          self.viewModel.onTrigger(.rename(id: viewModel.snipItem.id, name: name))
                                                        },
                                                        onToggleFavorite: {
                                                          self.viewModel.onTrigger(.toggleFavorite(id: viewModel.snipItem.id))
                                                        },
                                                        onDelete: {
                                                          self.viewModel.onTrigger(.delete(id: viewModel.snipItem.id))
                                                          self.viewModel.onDimiss()
                                                        },
                                                        onUpload: {
                                                          self.viewModel.onTrigger(.createGist(id: viewModel.snipItem.id))
                                                        },
                                                        onPreviewToggle: viewModel.snipItem.mode == CodeMode.html.mode() || viewModel.snipItem.mode == CodeMode.markdown.mode() ? {
                                                          withAnimation(Animation.easeOut(duration: 0.6)) { () -> () in
                                                            self.shouldShowPreview.toggle()
                                                          }
                                                        } : nil
      ))
      
      ModeSelectionView(viewModel: ModeSelectionViewModel(snippetMode: viewModel.snipItem.mode,
                                                          snippetTags: viewModel.snipItem.tags,
                                                          onModeSelection: { mode in
                                                            self.viewModel.onTrigger(.updateMode(id: viewModel.snipItem.id,
                                                                                                 mode: mode))
                                                          },
                                                          onTagChange: { tag, job in
                                                            self.viewModel.onTrigger(.updateTags(id: viewModel.snipItem.id,
                                                                                                 job: job,
                                                                                                 tag: tag))
                                                          }))
      
      
      GeometryReader { reader in
        HStack {
          CodeView(theme: settings.codeViewTheme,
                   code: .constant(viewModel.snipItem.snippet),
                   mode: .constant(viewModel.snipItem.mode),
                   fontSize: settings.codeViewTextSize,
                   showInvisibleCharacters: settings.codeViewShowInvisibleCharacters,
                   lineWrapping: settings.codeViewLineWrapping,
                   onContentChange: { newCode in
                    viewModel.saveNewCodeSnippet(newCode)
                   })
            .frame(width: self.shouldShowPreview ? reader.size.width / 2 : reader.size.width, height: reader.size.height)
          
          
          if self.shouldShowPreview {
            Divider()
            
            MarkdownHTMLViewer(code: viewModel.snipItem.snippet, mode: viewModel.snipItem.mode)
              .frame(width: reader.size.width / 2, height: reader.size.height)
              .background(Color.GREY_200)
              .transition(AnyTransition.move(edge: .trailing))
          }
        }
      }
      
      Divider()
      
      CodeDetailsBottomBar(viewModel: CodeDetailsViewModel(snippetCode: viewModel.snipItem.snippet))
    }
    .frame(minWidth: 0,
           maxWidth: .infinity,
           minHeight: 0,
           maxHeight: .infinity,
           alignment: .topLeading)
    .background(themePrimaryColor)
    .listStyle(PlainListStyle())
    
  }
}

final class CodeViewerViewModel: ObservableObject {
  
  @Published var snipItem: SnipItem
  var onTrigger: (SnipItemsListAction) -> Void
  var onDimiss: () -> Void
  
  init(snipItem: SnipItem,
       onTrigger: @escaping (SnipItemsListAction) -> Void,
       onDimiss: @escaping () -> Void) {
    
    self.snipItem = snipItem
    self.onTrigger = onTrigger
    self.onDimiss = onDimiss
  }
  
  func saveNewCodeSnippet(_ code: String) {
    onTrigger(.updateCode(id: snipItem.id, code: code))
  }
}

struct CodeViewer_Previews: PreviewProvider {
  static var previews: some View {
    CodeViewer(viewModel: CodeViewerViewModel(snipItem: Preview.snipItem,
                                              onTrigger: { _ in
                                                print("action")
                                              },
                                              onDimiss:  { print("onDismiss")}
    ))
    .environmentObject(Preview.snipItem)
  }
}


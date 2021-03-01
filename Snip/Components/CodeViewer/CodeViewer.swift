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
  
  var body: some View {
    Group {
      if let snipItem = viewModel.snipItem {
        VStack(alignment: .leading) {
          CodeActionsTopBar(viewModel: CodeActionsViewModel(name: snipItem.name,
                                                            code: snipItem.snippet,
                                                            isFavorite: snipItem.isFavorite,
                                                            lastUpdate: snipItem.lastUpdateDate,
                                                            syncState: snipItem.syncState ?? .local,
                                                            remoteURL: snipItem.remoteURL,
                                                            onRename: { name in
                                                              self.viewModel.onTrigger(.rename(id: snipItem.id, name: name))
                                                            },
                                                            onToggleFavorite: {
                                                              self.viewModel.onTrigger(.toggleFavorite(id: snipItem.id))
                                                            },
                                                            onDelete: {
                                                              self.viewModel.onTrigger(.delete(id: snipItem.id))
                                                              self.viewModel.onDimiss()
                                                            },
                                                            onUpload: {
                                                              self.viewModel.onTrigger(.createGist(id: snipItem.id))
                                                            },
                                                            onPreviewToggle: snipItem.mode == CodeMode.html.mode() || snipItem.mode == CodeMode.markdown.mode() ? {
                                                              withAnimation(Animation.easeOut(duration: 0.6)) { () -> () in
                                                                viewModel.shouldShowPreview.toggle()
                                                              }
                                                            } : nil
          ))
          
          
          if let modeSelectionViewModel = viewModel.modeSelectionViewModel {
            ModeSelectionView(viewModel: modeSelectionViewModel)
          }
          
          GeometryReader { reader in
            HStack {
              CodeView(theme: settings.codeViewTheme,
                       code: .constant(snipItem.snippet),
                       mode: .constant(snipItem.mode),
                       fontSize: settings.codeViewTextSize,
                       showInvisibleCharacters: settings.codeViewShowInvisibleCharacters,
                       lineWrapping: settings.codeViewLineWrapping,
                       onContentChange: { newCode in
                        viewModel.saveNewCodeSnippet(newCode)
                       })
                .frame(width: viewModel.shouldShowPreview ? reader.size.width / 2 : reader.size.width, height: reader.size.height)
              
              
              if viewModel.shouldShowPreview {
                Divider()
                
                MarkdownHTMLViewer(code: snipItem.snippet, mode: snipItem.mode)
                  .frame(width: reader.size.width / 2, height: reader.size.height)
                  .background(Color.GREY_200)
                  .transition(AnyTransition.move(edge: .trailing))
              }
            }
          }
          
          Divider()
          
          CodeDetailsBottomBar(viewModel: CodeDetailsViewModel(snippetCode: snipItem.snippet))
        }
      }
      else {
        emptyState
      }
    }
    .frame(minWidth: 0,
           maxWidth: .infinity,
           minHeight: 0,
           maxHeight: .infinity,
           alignment: .topLeading)
    .background(themePrimaryColor)
    .listStyle(PlainListStyle())
    
  }
  
  var emptyState: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        Text(NSLocalizedString("Create_first_snippet", comment: ""))
          .font(Font.custom("HelveticaNeue-Light", size: 20))
          .foregroundColor(settings.snipAppTheme == .auto ? .text : .white)
        Spacer()
      }
      HStack() {
        Spacer()
        Text(NSLocalizedString("Hint_1", comment: ""))
          .font(Font.custom("HelveticaNeue-Light", size: 16))
          .foregroundColor(settings.snipAppTheme == .auto ? .text : .white)
        Spacer()
      }
      .padding(.top, 8)
      HStack {
        Spacer()
        Text(NSLocalizedString("Hint_2", comment: ""))
          .font(Font.custom("HelveticaNeue-Light", size: 16))
          .foregroundColor(settings.snipAppTheme == .auto ? .text : .white)
        Spacer()
      }
      .padding(.top, 8)
      Spacer()
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    .background(settings.snipAppTheme == .auto ? Color.primary : Color.primaryTheme)
  }
}

final class CodeViewerViewModel: ObservableObject {
  
  @Published var snipItem: SnipItem?
  @Published var shouldShowPreview = false
  
  var onTrigger: (SnipItemsListAction) -> Void
  var onDimiss: () -> Void
  
  var modeSelectionViewModel: ModeSelectionViewModel?
  
  var cancellable: AnyCancellable?
  
  init(snipItem: AnyPublisher<SnipItem?, Never>,
       onTrigger: @escaping (SnipItemsListAction) -> Void,
       onDimiss: @escaping () -> Void) {
    
    self.onTrigger = onTrigger
    self.onDimiss = onDimiss
    
    cancellable = snipItem
      .sink { [weak self] (snipItem) in
        guard let this = self else { return }
        this.snipItem = snipItem
      }
    
    modeSelectionViewModel = ModeSelectionViewModel(snipItem: snipItem,
                                                    onModeSelection: { mode in
                                                      guard let snipItem = self.snipItem else { return }
                                                      self.onTrigger(.updateMode(id: snipItem.id,
                                                                                 mode: mode))
                                                    },
                                                    onTagChange: { tag, job in
                                                      guard let snipItem = self.snipItem else { return }
                                                      self.onTrigger(.updateTags(id: snipItem.id,
                                                                                 job: job,
                                                                                 tag: tag))
                                                    })
  }
  
  deinit {
    cancellable?.cancel()
  }
  
  func saveNewCodeSnippet(_ code: String) {
    guard let item = snipItem else { return }
    onTrigger(.updateCode(id: item.id, code: code))
  }
}

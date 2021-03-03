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
          
          if let codeActionsViewModel = viewModel.codeActionsViewModel {
            CodeActionsTopBar(viewModel: codeActionsViewModel)
          }
          
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
              
              
              if viewModel.shouldShowPreview,
                 let markdownHTMLViewerModel = viewModel.markdownHTMLViewerModel {
                Divider()
                
                MarkdownHTMLViewer(viewModel: markdownHTMLViewerModel)
                  .frame(width: reader.size.width / 2, height: reader.size.height)
                  .background(Color.GREY_200)
                  .transition(AnyTransition.move(edge: .trailing))
              }
            }
          }
          
          Divider()
          
          if let codeDetailsViewModel = viewModel.codeDetailsViewModel {
            CodeDetailsBottomBar(viewModel: codeDetailsViewModel)
          }
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
  var codeDetailsViewModel: CodeDetailsViewModel?
  var codeActionsViewModel: CodeActionsViewModel?
  var markdownHTMLViewerModel: MarkdownHTMLViewerModel?
  
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
    
    codeActionsViewModel = CodeActionsViewModel(snipItem: snipItem,
                                                onRename: { name in
                                                  guard let snipItem = self.snipItem else { return }
                                                  self.onTrigger(.rename(id: snipItem.id,
                                                                         name: name))
                                                },
                                                onToggleFavorite: {
                                                  guard let snipItem = self.snipItem else { return }
                                                  self.onTrigger(.toggleFavorite(id: snipItem.id))
                                                },
                                                onDelete: {
                                                  guard let snipItem = self.snipItem else { return }
                                                  self.onTrigger(.delete(id: snipItem.id))
                                                  self.onDimiss()
                                                },
                                                onUpload: {
                                                  guard let snipItem = self.snipItem else { return }
                                                  self.onTrigger(.createGist(id: snipItem.id))
                                                },
                                                onPreviewToggle: self.togglePreview)
    
    codeDetailsViewModel = CodeDetailsViewModel(snipItem: snipItem)
    markdownHTMLViewerModel = MarkdownHTMLViewerModel(snipItem: snipItem)
  }
  
  deinit {
    cancellable?.cancel()
  }
  
  func saveNewCodeSnippet(_ code: String) {
    guard let item = snipItem else { return }
    onTrigger(.updateCode(id: item.id, code: code))
  }
  
  func togglePreview() {
    withAnimation(Animation.easeOut(duration: 0.6)) { () -> () in
      shouldShowPreview.toggle()
    }
  }
}

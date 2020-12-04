//
//  SnipItemView.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/5/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI
import Combine


enum ModelFilter {
  case all
  case favorites
  case tag(tagTitle: String)
  
  enum Case { case all, favorites, tag }
  
  var `case`: Case {
    switch self {
      case .all: return .all
      case .favorites: return .favorites
      case .tag: return .tag
    }
  }
}



struct SnipItemView: View {
  
  @ObservedObject var viewModel: SnipItemViewModel
  
  @EnvironmentObject var appState: AppState
  @EnvironmentObject var settings: Settings
  
  
  @ViewBuilder
  var body: some View {
    
    if viewModel.snipItem.kind == .folder {
      
      HStack {
        
        Image("ic_folder_closed")
          .resizable()
          .renderingMode(.original)
          .colorMultiply(Color.BLUE_200)
          .scaledToFit()
          .frame(width: 15, height: 15, alignment: .center)
          .padding(.leading, 8)
        
        Text(self.viewModel.snipItem.name)
          .foregroundColor(self.appState.selectedSnippetId == self.viewModel.snipItem.id && self.appState.selectedSnippetFilter.case == self.viewModel.activeFilter.case ? .white : .text)
          .frame(maxWidth: .infinity, alignment: .leading)
          .background(Color.transparent)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(0)
      .buttonStyle(PlainButtonStyle())
      .contextMenu {
        Button(action: {
          self.viewModel.onTrigger(.addFolder(id: self.viewModel.snipItem.id))
        }) {
          Text("Add folder")
            .foregroundColor(.text)
        }
        
        Button(action: {
          self.viewModel.onTrigger(.addSnippet(id: self.viewModel.snipItem.id))
        }) {
          Text("Add snippet")
            .foregroundColor(.text)
        }
        
        Button(action: {
          self.viewModel.onTrigger(.delete(id: self.viewModel.snipItem.id))
        }) {
          Text("Delete")
            .foregroundColor(.text)
        }
      }
      
    }
    else {
      Button(action: viewModel.openSnippet) {
        HStack {
          Image(self.viewModel.snipItem.mode.imageName)
            .resizable()
            .renderingMode(self.appState.selectedSnippetId == self.viewModel.snipItem.id && self.appState.selectedSnippetFilter.case == self.viewModel.activeFilter.case ? .template : .original)
            .colorMultiply(.white)
            .scaledToFit()
            .frame(width: 15, height: 15, alignment: .center)
            .padding(.leading, 8)
          Text(self.viewModel.snipItem.name)
            .foregroundColor(self.appState.selectedSnippetId == self.viewModel.snipItem.id && self.appState.selectedSnippetFilter.case == self.viewModel.activeFilter.case ? .white : .text)
            .padding(.leading, 4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.transparent)
          
          Spacer()
          Circle()
            .fill(self.viewModel.snipItem.syncState == .local ? Color.clear : Color.green)
            .frame(width: 8, height: 8)
            .padding(.trailing, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        .background(Color.transparent)
      }
      .contextMenu {
        
        Button(action: {
          self.viewModel.onTrigger(.delete(id: self.viewModel.snipItem.id))
          self.appState.selectedSnippetId = nil
        }) {
          Text("Delete")
            .foregroundColor(.text)
        }
      }
      .buttonStyle(PlainButtonStyle())
      .background(self.appState.selectedSnippetId == self.viewModel.snipItem.id && self.appState.selectedSnippetFilter.case == self.viewModel.activeFilter.case ? .accentDark : Color.transparent)
      .cornerRadius(4)
    }
    
  }
  
}


final class SnipItemViewModel: ObservableObject {
  
  @Published var snipItem: SnipItem
  
  var activeFilter: ModelFilter
  var onTrigger: (SnipItemsListAction) -> Void
  var onSnippetSelection: (SnipItem, ModelFilter) -> Void
  
  init(snip: SnipItem,
       activeFilter: ModelFilter,
       onTrigger: @escaping (SnipItemsListAction) -> Void,
       onSnippetSelection: @escaping (SnipItem, ModelFilter) -> Void) {
    self.snipItem = snip
    self.activeFilter = activeFilter
    self.onTrigger = onTrigger
    self.onSnippetSelection = onSnippetSelection
  }
  
  func openSnippet() {
    onSnippetSelection(snipItem, activeFilter)
  }
}

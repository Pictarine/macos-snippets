//
//  SnipItemView.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/5/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI
import Combine


struct SnipItemView<Content: View>: View {
  
  @ObservedObject var viewModel: SnipItemViewModel
  
  @EnvironmentObject var settings: Settings
  @EnvironmentObject var appState: AppState
  
  @Environment(\.themePrimaryColor) var themePrimaryColor
  
  @State private var isExpanded: Bool = false
  @State private var isEditingName = false
  //@State var hasTriggered: Bool = false
  
  let content: () -> Content?
  
  @ViewBuilder
  var body: some View {
    
    if viewModel.snipItem.kind == .folder {
      
      Button(action: {
        
        if !isEditingName {
          isExpanded.toggle()
        }
      }) {
        
        HStack {
          
          VStack {
            Spacer()
            Image( isExpanded ? "ic_up" : "ic_down")
              .resizable()
              .renderingMode(.original)
              .colorMultiply(Color.GREY_500)
              .scaledToFit()
              .frame(width: 10, height: 10, alignment: .center)
            Spacer()
          }
          .padding(.leading, 8)
          
          Image( isExpanded ? "ic_folder_opened" : "ic_folder_closed")
            .resizable()
            .renderingMode(.original)
            .colorMultiply(Color.GREY_500)
            .scaledToFit()
            .frame(width: 15, height: 15, alignment: .center)
            .padding(.leading, 8)
          
          Group {
            if isEditingName {
              TextField(NSLocalizedString("Placeholder_Folder", comment: ""),
                        text: $viewModel.snipItem.name,
                        onEditingChanged: { _ in},
                        onCommit: {
                          isEditingName.toggle()
                          viewModel.onTrigger(.rename(id: viewModel.snipItem.id, name: viewModel.snipItem.name))
                        }
              )
              .foregroundColor(appState.selectedSnippetId == viewModel.snipItem.id && appState.selectedSnippetFilter.case == viewModel.activeFilter.case ? .white : .text)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
              .background(themePrimaryColor)
              /*.introspectTextField { textField in
                if self.hasTriggered == false {
                  textField.becomeFirstResponder()
                  self.hasTriggered = true
                }
              }
              .onAppear(perform: {self.hasTriggered = false})*/
              .onHover { inside in
                if inside {
                  NSCursor.iBeam.push()
                } else {
                  NSCursor.pop()
                }
              }
            }
            else {
              Text(viewModel.snipItem.name)
                .foregroundColor(appState.selectedSnippetId == viewModel.snipItem.id && appState.selectedSnippetFilter.case == viewModel.activeFilter.case ? .white : .text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                .background(Color.transparent)
            }
          }
          .background(Color.transparent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.transparent)
        
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(0)
      .background(Color.transparent)
      .buttonStyle(PlainButtonStyle())
      .onHover { inside in
        if inside {
          NSCursor.pointingHand.push()
        } else {
          NSCursor.pop()
        }
      }
      .contextMenu {
        Button(action: {
          viewModel.onTrigger(.addFolder(id: viewModel.snipItem.id))
          isExpanded = true
        }) {
          Text(NSLocalizedString("Add_Folder", comment: ""))
            .foregroundColor(.text)
        }
        
        Button(action: {
          viewModel.onTrigger(.addSnippet(id: viewModel.snipItem.id, settings: settings))
          isExpanded = true
        }) {
          Text(NSLocalizedString("Add_Snippet", comment: ""))
            .foregroundColor(.text)
        }
        
        Button(action: {
          viewModel.onTrigger(.folderFromSelection(id: viewModel.snipItem.id))
          isExpanded = false
        }) {
          Text(NSLocalizedString("Folder_From", comment: ""))
            .foregroundColor(.text)
        }
        
        Button(action: {
          isEditingName.toggle()
          isExpanded = false
        }) {
          Text(NSLocalizedString("Rename", comment: ""))
            .foregroundColor(.text)
        }
        
        Button(action: {
          viewModel.onTrigger(.delete(id: viewModel.snipItem.id))
        }) {
          Text(NSLocalizedString("Delete", comment: ""))
            .foregroundColor(.text)
        }
      }
      
    }
    else {
      Button(action: viewModel.openSnippet) {
        HStack {
          Image(viewModel.snipItem.mode.imageName)
            .resizable()
            .renderingMode(appState.selectedSnippetId == viewModel.snipItem.id && appState.selectedSnippetFilter.case == viewModel.activeFilter.case ? .template : .original)
            .colorMultiply(.white)
            .scaledToFit()
            .frame(width: 15, height: 15, alignment: .center)
            .padding(.leading, 8)
          
          Group {
            if isEditingName {
              TextField(NSLocalizedString("Placeholder_Snip", comment: ""),
                        text: $viewModel.snipItem.name,
                        onEditingChanged: { _ in },
                        onCommit: {
                          isEditingName.toggle()
                          viewModel.onTrigger(.rename(id: viewModel.snipItem.id, name: viewModel.snipItem.name))
                        }
              )
              .foregroundColor(appState.selectedSnippetId == viewModel.snipItem.id && appState.selectedSnippetFilter.case == viewModel.activeFilter.case ? .white : .text)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.leading, 4)
              .background(themePrimaryColor)
              /*.introspectTextField { textField in
                if self.hasTriggered == false {
                  textField.becomeFirstResponder()
                  self.hasTriggered = true
                }
              }
              .onAppear(perform: {self.hasTriggered = false})*/
              .onHover { inside in
                if inside {
                  NSCursor.iBeam.push()
                } else {
                  NSCursor.pop()
                }
              }
            }
            else {
              Text(self.viewModel.snipItem.name)
                .foregroundColor(appState.selectedSnippetId == viewModel.snipItem.id && appState.selectedSnippetFilter.case == viewModel.activeFilter.case ? .white : .text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 4)
                .background(Color.transparent)
            }
          }
          .background(Color.transparent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        .background(Color.transparent)
      }
      .onHover { inside in
        if inside {
          NSCursor.pointingHand.push()
        } else {
          NSCursor.pop()
        }
      }
      .contextMenu {
        
        Button(action: {
          viewModel.onTrigger(.folderFromSelection(id: viewModel.snipItem.id))
        }) {
          Text(NSLocalizedString("Folder_From", comment: ""))
            .foregroundColor(.text)
        }
        
        Button(action: {
          isEditingName.toggle()
        }) {
          Text(NSLocalizedString("Rename", comment: ""))
            .foregroundColor(.text)
        }
        
        Button(action: {
          viewModel.onTrigger(.delete(id: viewModel.snipItem.id))
          appState.selectedSnippetId = nil
        }) {
          Text(NSLocalizedString("Delete", comment: ""))
            .foregroundColor(.text)
        }
      }
      .buttonStyle(PlainButtonStyle())
      .background(appState.selectedSnippetId == viewModel.snipItem.id && appState.selectedSnippetFilter.case == viewModel.activeFilter.case ? .accentDark : Color.transparent)
      .cornerRadius(4)
    }
    
    if isExpanded {
      content()
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

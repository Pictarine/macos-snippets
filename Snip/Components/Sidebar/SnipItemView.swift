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
  @EnvironmentObject var appState: AppState
  @State private var isExpanded: Bool = false
  @State private var isEditingName = false
  
  let content: () -> Content?
  
  @ViewBuilder
  var body: some View {
    
    if viewModel.snipItem.kind == .folder {
      
      Button(action: {
        self.isExpanded.toggle()
      },
             label: {
              HStack {
                VStack {
                  Spacer()
                  Image( self.isExpanded ? "ic_up" : "ic_down")
                    .resizable()
                    .renderingMode(.template)
                    .colorMultiply(self.appState.selectedSnippetId == self.viewModel.snipItem.id && self.appState.selectedSnippetFilter.case == self.viewModel.activeFilter.case ? .white : .text)
                    .scaledToFit()
                    .frame(width: 10, height: 10, alignment: .center)
                  Spacer()
                }
                
                Image( self.isExpanded ? "ic_folder_opened" : "ic_folder_closed")
                  .resizable()
                  .renderingMode(.template)
                  .colorMultiply(self.appState.selectedSnippetId == self.viewModel.snipItem.id && self.appState.selectedSnippetFilter.case == self.viewModel.activeFilter.case ? .white : .text)
                  .scaledToFit()
                  .frame(width: 15, height: 15, alignment: .center)
                
                TextField("Snip name", text: Binding<String>(
                  get: {
                    self.viewModel.snipItem.name
                }, set: {
                  self.viewModel.snipItem.name = $0
                  self.viewModel.onTrigger(.rename(id: self.viewModel.snipItem.id, name: $0))
                }),
                          onEditingChanged: { _ in
                            
                },
                          onCommit: {
                            self.isEditingName.toggle()
                }
                )
                  .disabled(isEditingName == false)
                  .foregroundColor(self.appState.selectedSnippetId == self.viewModel.snipItem.id && self.appState.selectedSnippetFilter.case == self.viewModel.activeFilter.case ? .white : .text)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .background(isEditingName ? .primary : Color.transparent)
              }
              .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
              .background(Color.transparent)
              .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
      })
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
          
          Button(action: { self.isEditingName.toggle() }) {
            Text("Rename")
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
      NavigationLink(destination: DeferView {
        CodeViewer(viewModel: CodeViewerViewModel(onTrigger: self.viewModel.onTrigger,
                                                  onDimiss: {
                                                    self.appState.selectedSnippetId = nil
        }))
          .environmentObject(Settings())
          .environmentObject(self.appState)
          .environmentObject(self.viewModel.snipItem)
          .onAppear {
            self.appState.selectedSnippetId = self.viewModel.snipItem.id
            self.appState.selectedSnippetFilter = self.viewModel.activeFilter
        }
        .onDisappear {
          self.appState.selectedSnippetId = nil
        }
      }) {
        HStack {
          Image(self.viewModel.snipItem.mode.imageName)
            .resizable()
            .renderingMode(.original)
            .colorMultiply(self.appState.selectedSnippetId == self.viewModel.snipItem.id && self.appState.selectedSnippetFilter.case == self.viewModel.activeFilter.case ? .white : .text)
            .scaledToFit()
            .frame(width: 15, height: 15, alignment: .center)
            .padding(.leading, 4)
          TextField("Snip name", text: Binding<String>(
            get: {
              self.viewModel.snipItem.name
          }, set: {
            self.viewModel.snipItem.name = $0
            self.viewModel.onTrigger(.rename(id: self.viewModel.snipItem.id, name: $0))
          }),
                    onEditingChanged: { _ in
                      
          },
                    onCommit: {
                      self.isEditingName.toggle()
          }
          )
            .disabled(isEditingName == false)
            .foregroundColor(self.appState.selectedSnippetId == self.viewModel.snipItem.id && self.appState.selectedSnippetFilter.case == self.viewModel.activeFilter.case ? .white : .text)
            .padding(.leading, 4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isEditingName ? .primary : Color.transparent)
          Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
      }
      .contextMenu {
        Button(action: {
          self.isEditingName.toggle()
        }) {
          Text("Rename")
          .foregroundColor(.text)
        }
        
        Button(action: {
          self.viewModel.onTrigger(.delete(id: self.viewModel.snipItem.id))
          self.appState.selectedSnippetId = nil
        }) {
          Text("Delete")
            .foregroundColor(.text)
        }
      }
      .listRowBackground(self.appState.selectedSnippetId == self.viewModel.snipItem.id && self.appState.selectedSnippetFilter.case == self.viewModel.activeFilter.case ? .accentDark : Color.transparent)
      
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
  
  init(snip: SnipItem, activeFilter: ModelFilter, onTrigger: @escaping (SnipItemsListAction) -> Void) {
    self.snipItem = snip
    self.activeFilter = activeFilter
    self.onTrigger = onTrigger
  }
  
}

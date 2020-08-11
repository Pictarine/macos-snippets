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
  @State var isExpanded: Bool = false
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
                Image( self.isExpanded ? "ic_up" : "ic_down")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 15, height: 15, alignment: .center)
                
                Image( self.isExpanded ? "ic_folder_opened" : "ic_folder_closed")
                  .resizable()
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
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .background(isEditingName ? Color.BLACK_500 : Color.black.opacity(0.0001))
              }
                
              .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
              .background(Color.clear)
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
          }
          
          Button(action: {
            self.viewModel.onTrigger(.addSnippet(id: self.viewModel.snipItem.id))
          }) {
            Text("Add snippet")
          }
          
          Button(action: { self.isEditingName.toggle() }) {
            Text("Rename")
          }
          
          Button(action: {
            self.viewModel.onTrigger(.delete(id: self.viewModel.snipItem.id))
          }) {
            Text("Delete")
          }
      }
      
    }
    else {
      NavigationLink(destination: DeferView {
        CodeViewer(viewModel: CodeViewerViewModel(onTrigger: self.viewModel.onTrigger))
          .environmentObject(Settings())
          .environmentObject(self.viewModel.snipItem)
          .onAppear {
            self.appState.selectedSnippetId = self.viewModel.snipItem.id
            self.appState.selectedSnippetFilter = self.viewModel.activeFilter
        }
        .onDisappear {
          self.appState.selectedSnippetId = nil
        }
        }
        /*, tag: viewModel.snipItem.id,
       selection: $appState.selectedSnippetId*/) {
        HStack {
          Image("ic_snippet")
            .resizable()
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
            .padding(.leading, 4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isEditingName ? Color.BLACK_500 : Color.black.opacity(0.0001))
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
        }
        
        Button(action: {
          self.viewModel.onTrigger(.delete(id: self.viewModel.snipItem.id))
        }) {
          Text("Delete")
        }
      }
      .listRowBackground(self.appState.selectedSnippetId == self.viewModel.snipItem.id && self.appState.selectedSnippetFilter.case == self.viewModel.activeFilter.case ? Color.PURPLE_700 : Color.clear)
      
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

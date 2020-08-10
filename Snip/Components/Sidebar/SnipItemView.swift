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
  @State var isExpanded: Bool = false
  
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
                Text(viewModel.snipItem.name)
                  
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .background(Color.black.opacity(0.0001))
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
          
          Button(action: { }) {
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
      NavigationLink(destination: //DeferView {
        CodeViewer(viewModel: CodeViewerViewModel(onTrigger: self.viewModel.onTrigger))
        .environmentObject(Settings())
        .environmentObject(self.viewModel.snipItem)
        //}
      , tag: viewModel.snipItem.id,
        selection: viewModel.$selection) {
        HStack {
          Image("ic_file")
            .resizable()
            .frame(width: 15, height: 15, alignment: .center)
            .padding(.leading, 4)
          Text(viewModel.snipItem.name)
            .padding(.leading, 4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.black.opacity(0.0001))
          Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
      }
      .contextMenu {
        Button(action: {
          self.viewModel.selection = self.viewModel.snipItem.id
        }) {
          Text("Rename")
        }
        
        Button(action: {
          self.viewModel.onTrigger(.delete(id: self.viewModel.snipItem.id))
          self.viewModel.selection = self.viewModel.snipItem.id
        }) {
          Text("Delete")
        }
      }
      .listRowBackground(self.viewModel.selection == self.viewModel.snipItem.id ? Color.PURPLE_700 : Color.clear)
      
    }
    
    if isExpanded {
      content()
    }
    
    
  }
  
}


final class SnipItemViewModel: ObservableObject {
  
  @Published var snipItem: SnipItem
  
  @Binding var selection: String?
  
  var onTrigger: (SnipItemsListAction) -> Void
  
  init(snip: SnipItem, selectedItem: Binding<String?>, onTrigger: @escaping (SnipItemsListAction) -> Void) {
    snipItem = snip
    _selection = selectedItem
    self.onTrigger = onTrigger
  }
  
}

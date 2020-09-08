//
//  ExternalSnippet.swift
//  Snip
//
//  Created by Anthony Fernandez on 9/7/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct ExternalSnippet: View {
  
  @ObservedObject var viewModel: ExternalSnippetViewModel
  @ObservedObject var snippetManager = SnippetManager.shared
  
  var body: some View {
    ZStack {
      
      VStack(alignment: .leading) {
        VStack {
          TextField("Snippet name", text: self.$viewModel.tempSnipItem.name)
            .font(Font.custom("HelveticaNeue", size: 20))
            .foregroundColor(.text)
            .frame(maxWidth: .infinity)
            .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(EdgeInsets(top: 8,
                            leading: 4,
                            bottom: 8,
                            trailing: 4))
          .background(Color.secondary.opacity(0.8))
        
        Picker(selection: Binding<Int>(
                get: {
                  let index = self.viewModel.modesList.firstIndex(where: { (mode) -> Bool in
                    mode == self.viewModel.tempSnipItem.mode
                  }) ?? -1
                  return index
                },
                  set: {
                    self.viewModel.tempSnipItem.mode = self.viewModel.modesList[$0]
                    self.viewModel.objectWillChange.send()
                }),
               label: EmptyView()) {
                ForEach(0 ..< self.viewModel.modesList.count, id: \.self) {
                  Text(self.viewModel.modesList[$0].name)
                }
        }
        .frame(minWidth: 100,
               idealWidth: 150,
               maxWidth: 150,
               alignment: .leading)
          .pickerStyle(DefaultPickerStyle())
        
        CodeView(code: .constant(self.viewModel.tempSnipItem.snippet),
                 mode: .constant(self.viewModel.tempSnipItem.mode),
                 onContentChange: { newCode in
                  self.viewModel.tempSnipItem.snippet = newCode
                  self.viewModel.objectWillChange.send()
        })
          .frame(maxWidth: .infinity,
                 maxHeight: .infinity)
        
        HStack {
          Spacer()
          Button(action: {
            
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.3)) { () -> () in
              self.snippetManager.hasExternalSnippetQueued = false
              self.snippetManager.tempSnipItem = nil
            }
          }) {
            Text("Cancel")
              .foregroundColor(.white)
              .padding(4)
          }
          .buttonStyle(PlainButtonStyle())
          .background(Color.transparent)
          
          Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.3)) { () -> () in
              self.viewModel.onTrigger(.addExternalSnippet(name: self.snippetManager.tempSnipItem?.name,
                                                           code: self.snippetManager.tempSnipItem?.snippet,
                                                           tags: self.snippetManager.tempSnipItem?.tags,
                                                           source: self.snippetManager.tempSnipItem?.remoteURL))
              self.snippetManager.hasExternalSnippetQueued = false
              self.snippetManager.tempSnipItem = nil
            }
          }) {
            Text("Add Snippet")
              .foregroundColor(.white)
              .padding(8)
          }
          .buttonStyle(PlainButtonStyle())
          .background(Color.accent)
          .cornerRadius(4)
        }
      }
      .frame(width: viewModel.size.width / 2.5,
             height: viewModel.size.height / 1.5,
             alignment: .center)
        .padding()
        .background(Color.primary)
        .cornerRadius(4.0)
        .offset(x: 0,
                y: self.snippetManager.hasExternalSnippetQueued ? ((viewModel.size.height / 2) - ((viewModel.size.height / 1.5) / 1.5)) : 10000)
        .transition(AnyTransition.move(edge: .bottom))
    }
  }
}

final class ExternalSnippetViewModel: ObservableObject {
  
  @Published var tempSnipItem: SnipItem
  
  var onTrigger: (SnipItemsListAction) -> Void
  var size: CGSize
  
  let modesList = CodeMode.list()
  
  init(tempSnipItem: SnipItem,
       readerSize: CGSize,
       onTrigger: @escaping (SnipItemsListAction) -> Void) {
    self.tempSnipItem = tempSnipItem
    self.size = readerSize
    self.onTrigger = onTrigger
  }
}

struct ExternalSnippet_Previews: PreviewProvider {
  static var previews: some View {
    ExternalSnippet(viewModel: ExternalSnippetViewModel(tempSnipItem: SnipItem.file(name: "Test"),
                                                        readerSize: CGSize(width: 400,
                                                                           height: 300),
                                                        onTrigger: {_ in }))
  }
}

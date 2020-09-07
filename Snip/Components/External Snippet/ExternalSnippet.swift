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
          TextField("Snippet name", text: .constant(self.snippetManager.tempSnipItem?.name ?? ""))
            .font(Font.custom("HelveticaNeue", size: 20))
            .foregroundColor(.text)
            .frame(maxWidth: .infinity)
            .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4))
        .background(Color.secondary.opacity(0.8))
        
        CodeView(code: .constant(self.snippetManager.tempSnipItem?.snippet ?? ""),
                 mode: .constant(self.snippetManager.tempSnipItem?.mode ?? CodeMode.json.mode()),
                 onContentChange: { newCode in
                  self.snippetManager.tempSnipItem?.snippet = newCode
        })
          .frame(maxWidth: .infinity,
                 maxHeight: .infinity)
        
        HStack {
          Spacer()
          Button(action: {
            
            withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 40.0, damping: 11, initialVelocity: 0)) { () -> () in
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
            withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 40.0, damping: 11, initialVelocity: 0)) { () -> () in
              self.viewModel.onTrigger(.addExternalSnippet(name: self.snippetManager.tempSnipItem?.name,
                                                           code: self.snippetManager.tempSnipItem?.snippet,
                                                           tags: self.snippetManager.tempSnipItem?.tags))
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
      .frame(width: viewModel.size.width / 2.5, height: viewModel.size.height / 1.5, alignment: .center)
      .padding()
      .background(Color.primary)
      .cornerRadius(4.0)
      .offset(x: 0, y: self.snippetManager.hasExternalSnippetQueued ? ((viewModel.size.height / 2) - ((viewModel.size.height / 1.5) / 1.5)) : 10000)
      .transition(AnyTransition.move(edge: .bottom))
    }
  }
}

final class ExternalSnippetViewModel: ObservableObject {
  
  var size: CGSize
  var onTrigger: (SnipItemsListAction) -> Void
  
  init(readerSize: CGSize,
       onTrigger: @escaping (SnipItemsListAction) -> Void) {
    self.size = readerSize
    self.onTrigger = onTrigger
  }
}

struct ExternalSnippet_Previews: PreviewProvider {
  static var previews: some View {
    ExternalSnippet(viewModel: ExternalSnippetViewModel(readerSize: CGSize(width: 0, height: 0),
                                                        onTrigger: {_ in }))
  }
}

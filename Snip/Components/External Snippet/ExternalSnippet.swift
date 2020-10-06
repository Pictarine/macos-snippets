//
//  ExternalSnippet.swift
//  Snip
//
//  Created by Anthony Fernandez on 9/7/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct ExternalSnippet: View {
  
  @EnvironmentObject var settings: Settings
  @ObservedObject var viewModel: ExternalSnippetViewModel
  @Binding var externalSnipItem: ExternalSnipItem
  
  var body: some View {
    ZStack {
      
      backgroundView
        .frame(width: viewModel.size.width, height: viewModel.size.height)
        .transition(AnyTransition.opacity)
      
      VStack(alignment: .leading) {
        VStack {
          TextField("Snippet name", text: self.$externalSnipItem.name)
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
                    mode == self.externalSnipItem.mode
                  }) ?? -1
                  return index
                },
                set: {
                  self.externalSnipItem.mode = self.viewModel.modesList[$0]
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
        
        CodeView(theme: settings.codeViewTheme,
                 code: .constant(self.externalSnipItem.snippet),
                 mode: .constant(self.externalSnipItem.mode),
                 fontSize: settings.codeViewTextSize,
                 showInvisibleCharacters: settings.codeViewShowInvisibleCharacters,
                 lineWrapping: settings.codeViewLineWrapping)
          .onContentChange { newCode in
            self.externalSnipItem.snippet = newCode
          }
          .frame(maxWidth: .infinity,
                 maxHeight: .infinity)
        
        HStack {
          Spacer()
          Button(action: {
            
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.3)) { () -> () in
              self.viewModel.onCancel()
            }
          }) {
            Text("Cancel")
              .foregroundColor(Color.text)
              .padding(4)
          }
          .buttonStyle(PlainButtonStyle())
          .background(Color.transparent)
          
          Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.3)) { () -> () in
              self.viewModel.onTrigger(.addExternalSnippet(externalSnipItem: self.externalSnipItem))
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
              y: self.viewModel.isVisible ? ((viewModel.size.height / 2) - ((viewModel.size.height / 1.5) / 1.5)) : 10000)
      .transition(AnyTransition.move(edge: .bottom))
    }
  }
  
  var backgroundView: some View {
    self.viewModel.isVisible ? Color.shadow : Color.clear
  }
}

final class ExternalSnippetViewModel: ObservableObject {
  
  var onTrigger: (SnipItemsListAction) -> Void
  var onCancel: () -> Void
  var isVisible: Bool
  var size: CGSize
  
  let modesList = CodeMode.list()
  
  init(isVisible: Bool,
       readerSize: CGSize,
       onTrigger: @escaping (SnipItemsListAction) -> Void,
       onCancel: @escaping () -> Void) {
    self.isVisible = isVisible
    self.size = readerSize
    self.onTrigger = onTrigger
    self.onCancel = onCancel
  }
}

struct ExternalSnippet_Previews: PreviewProvider {
  static var previews: some View {
    ExternalSnippet(viewModel: ExternalSnippetViewModel(isVisible: true,
                                                        readerSize: CGSize(width: 400, height: 300),
                                                        onTrigger: {_ in },
                                                        onCancel: {}),
                    externalSnipItem: .constant(ExternalSnipItem.blank()))
  }
}

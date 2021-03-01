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
  
  @Environment(\.themePrimaryColor) var themePrimaryColor
  @Environment(\.themeSecondaryColor) var themeSecondaryColor
  @Environment(\.themeTextColor) var themeTextColor
  @Environment(\.themeShadowColor) var themeShadowColor
  
  @ObservedObject var viewModel: ExternalSnippetViewModel
  
  @Binding var externalSnipItem: ExternalSnipItem
  
  var body: some View {
    ZStack {
      
      backgroundView
        .frame(width: viewModel.size.width, height: viewModel.size.height)
        .transition(AnyTransition.opacity)
      
      VStack(alignment: .leading) {
        VStack {
          TextField(NSLocalizedString("Placeholder_Snip", comment: ""), text: $externalSnipItem.name)
            .font(Font.custom("HelveticaNeue", size: 20))
            .foregroundColor(themeTextColor)
            .frame(maxWidth: .infinity)
            .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(EdgeInsets(top: 8,
                            leading: 4,
                            bottom: 8,
                            trailing: 4))
        .background(themeSecondaryColor.opacity(0.8))
        
        Picker(selection: Binding<Int>(
                get: {
                  let index = viewModel.modesList.firstIndex(where: { (mode) -> Bool in
                    mode == externalSnipItem.mode
                  }) ?? -1
                  return index
                },
                set: {
                  self.externalSnipItem.mode = viewModel.modesList[$0]
                }),
               label: EmptyView()) {
          ForEach(0 ..< self.viewModel.modesList.count, id: \.self) {
            Text(viewModel.modesList[$0].name)
          }
        }
        .frame(minWidth: 100,
               idealWidth: 150,
               maxWidth: 150,
               alignment: .leading)
        .pickerStyle(DefaultPickerStyle())
        
        CodeView(theme: settings.codeViewTheme,
                 code: .constant(externalSnipItem.snippet),
                 mode: .constant(externalSnipItem.mode),
                 fontSize: settings.codeViewTextSize,
                 showInvisibleCharacters: settings.codeViewShowInvisibleCharacters,
                 lineWrapping: settings.codeViewLineWrapping,
                 onContentChange: { newCode in
                  externalSnipItem.snippet = newCode
                 })
          .frame(maxWidth: .infinity,
                 maxHeight: .infinity)
        
        HStack {
          Spacer()
          Button(action: {
            
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.3)) { () -> () in
              viewModel.onCancel()
            }
          }) {
            Text(NSLocalizedString("Cancel", comment: ""))
              .foregroundColor(themeTextColor)
              .padding(4)
              .background(Color.transparent)
          }
          .buttonStyle(PlainButtonStyle())
          .background(Color.transparent)
          
          Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.3)) { () -> () in
              viewModel.onTrigger(.addExternalSnippet(externalSnipItem: externalSnipItem))
            }
          }) {
            Text(NSLocalizedString("Add_Snippet", comment: ""))
              .foregroundColor(.white)
              .padding(8)
              .background(Color.transparent)
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
      .background(themePrimaryColor)
      .cornerRadius(4.0)
      .offset(x: 0,
              y: viewModel.isVisible ? ((viewModel.size.height / 2) - ((viewModel.size.height / 1.5) / 1.5)) : 10000)
      .transition(AnyTransition.move(edge: .bottom))
    }
  }
  
  var backgroundView: some View {
    viewModel.isVisible ? themeShadowColor : Color.clear
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

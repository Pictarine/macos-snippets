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
            viewModel.close()
          }
        }) {
          Text(NSLocalizedString("Cancel", comment: ""))
            .foregroundColor(themeTextColor)
            .padding(4)
            .background(Color.transparent)
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.transparent)
        .onHover { inside in
          if inside {
            NSCursor.pointingHand.push()
          } else {
            NSCursor.pop()
          }
        }
        
        Button(action: {
          withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.3)) { () -> () in
            viewModel.onTrigger(.addExternalSnippet(externalSnipItem: externalSnipItem))
            viewModel.close()
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
        .onHover { inside in
          if inside {
            NSCursor.pointingHand.push()
          } else {
            NSCursor.pop()
          }
        }
      }
    }
    .padding()
    .background(themePrimaryColor)
    .cornerRadius(4.0)
  }
}

final class ExternalSnippetViewModel: ObservableObject {
  
  @Binding var isVisible: Bool
  
  var onTrigger: (SnipItemsListAction) -> Void
  
  let modesList = CodeMode.list()
  
  init(isVisible: Binding<Bool>,
       onTrigger: @escaping (SnipItemsListAction) -> Void) {
    self._isVisible = isVisible
    self.onTrigger = onTrigger
  }
  
  func close() {
    self.isVisible = false
  }
}

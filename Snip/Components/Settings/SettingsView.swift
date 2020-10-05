//
//  SettingsView.swift
//  Snip
//
//  Created by Anthony Fernandez on 9/7/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
  
  @EnvironmentObject var settings: Settings
  @ObservedObject var viewModel: SettingsViewModel
  
  @State private var selectedTheme = 0
  @State private var codeBlock = try! String(contentsOf: Bundle.main.url(forResource: "Demo", withExtension: "txt")!)
  
  var body: some View {
    ZStack {
      
      backgroundView
        .frame(width: viewModel.size.width, height: viewModel.size.height)
        .transition(AnyTransition.opacity)
      
      VStack(alignment: .leading) {
        
        HStack {
          Spacer()
          Text("Settings")
            .font(.largeTitle)
          Spacer()
        }
        .padding(.top, 16)
        
        Picker(selection: Binding<Int>(
                get: {
                  let index = CodeViewTheme.list.firstIndex(where: { (theme) -> Bool in
                    theme == settings.codeMirrorTheme
                  }) ?? 0
                  return index
                },
                set: {
                  selectedTheme = $0
                  settings.codeMirrorTheme = CodeViewTheme.list[$0]
                }), label: Text("CodeView Theme")) {
          ForEach(0 ..< CodeViewTheme.list.count) {
            Text(CodeViewTheme.list[$0].rawValue)
          }
        }
        .pickerStyle(DefaultPickerStyle())
        .frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
        
        CodeView(theme: settings.codeMirrorTheme,
                 code: $codeBlock,
                 mode: .constant(CodeMode.swift.mode()),
                 isReadOnly: true)
          .frame(maxWidth: .infinity, maxHeight: 150)
          .padding(EdgeInsets(top: 16, leading: 32, bottom: 0, trailing: 32))
        
        Spacer()
        
        HStack {
          Spacer()
          Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.3)) { () -> () in
              settings.isSettingsOpened.toggle()
            }
          }) {
            Text("Close")
              .foregroundColor(.white)
              .frame(width: 50)
              .padding(8)
          }
          .buttonStyle(PlainButtonStyle())
          .background(Color.accent)
          .cornerRadius(4)
          Spacer()
        }
        .padding(8)
      }
      .frame(width: viewModel.size.width / 2.5,
             height: viewModel.size.height / 1.5,
             alignment: .center)
      .background(Color.primary)
      .cornerRadius(4.0)
      .offset(x: 0,
              y: viewModel.isVisible ? (( viewModel.size.height / 2) - ((viewModel.size.height / 1.5) / 1.5)) : 10000)
      .transition(AnyTransition.move(edge: .bottom))
      
    }
  }
  
  var backgroundView: some View {
    viewModel.isVisible ? Color.black.opacity(0.8) : Color.clear
  }
}

final class SettingsViewModel: ObservableObject {
  
  var isVisible: Bool
  var size: CGSize
  
  init(isVisible: Bool, readerSize: CGSize) {
    self.isVisible = isVisible
    self.size = readerSize
  }
  
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView(viewModel: SettingsViewModel(isVisible: true,
                                              readerSize: CGSize(width: 400,height: 300)))
  }
}

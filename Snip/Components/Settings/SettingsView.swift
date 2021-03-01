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
  
  @Environment(\.themePrimaryColor) var themePrimaryColor
  @Environment(\.themeTextColor) var themeTextColor
  @Environment(\.themeShadowColor) var themeShadowColor
  
  @ObservedObject var viewModel: SettingsViewModel
  
  @State private var selectedTheme = 0
  @State private var selectedAppTheme = 0
  @State private var codeBlock = try! String(contentsOf: Bundle.main.url(forResource: "Demo", withExtension: "txt")!)
  
  var body: some View {
    ZStack {
      
      backgroundView
        .frame(width: viewModel.size.width, height: viewModel.size.height)
        .transition(AnyTransition.opacity)
      
      VStack(alignment: .leading) {
        
        HStack {
          Spacer()
          Text(NSLocalizedString("Settings", comment: ""))
            .font(.largeTitle)
            .foregroundColor(themeTextColor)
          Spacer()
        }
        .padding(.top, 16)
        
        
        Picker(selection: Binding<Int>(
                get: {
                  let index = SnipAppTheme.allCases.firstIndex(where: { (theme) -> Bool in
                    theme == settings.snipAppTheme
                  }) ?? 0
                  return index
                },
                set: {
                  selectedAppTheme = $0
                  settings.snipAppTheme = SnipAppTheme.allCases[$0]
                }), label:
                  Text(NSLocalizedString("App_Theme", comment: ""))
                  .foregroundColor(themeTextColor)
        ) {
          ForEach(0 ..< SnipAppTheme.allCases.count) { index in
            Text(SnipAppTheme.allCases[index].rawValue).tag(index)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
        Divider()
          .padding(EdgeInsets(top: 4, leading: 16, bottom: 0, trailing: 16))
        
        Group {
          Picker(selection: Binding<Int>(
                  get: {
                    let index = CodeViewTheme.list.firstIndex(where: { (theme) -> Bool in
                      theme == settings.codeViewTheme
                    }) ?? 0
                    return index
                  },
                  set: {
                    selectedTheme = $0
                    settings.codeViewTheme = CodeViewTheme.list[$0]
                  }), label:
                    Text(NSLocalizedString("CD_Theme", comment: ""))
                    .foregroundColor(themeTextColor)
          ) {
            ForEach(0 ..< CodeViewTheme.list.count) {
              Text(CodeViewTheme.list[$0].rawValue)
            }
          }
          .pickerStyle(DefaultPickerStyle())
          .frame(maxWidth: .infinity)
          .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
          Divider()
            .padding(EdgeInsets(top: 4, leading: 16, bottom: 0, trailing: 16))
          
          ToggleItem(option: Binding<Bool>(
                      get: {
                        return settings.codeViewShowInvisibleCharacters
                      },
                      set: {
                        settings.codeViewShowInvisibleCharacters = $0
                      }),
                     optionText: NSLocalizedString("CD_Invisible_Char", comment: ""))
          
          ToggleItem(option: Binding<Bool>(
                      get: {
                        return settings.codeViewLineWrapping
                      },
                      set: {
                        settings.codeViewLineWrapping = $0
                      }),
                     optionText: NSLocalizedString("CD_Line_Wrapping", comment: ""))
        }
        
        HStack {
          Text(NSLocalizedString("CD_Text_size", comment: ""))
            .foregroundColor(themeTextColor)
          Spacer()
          Slider(value: Binding<Float>(
                  get: {
                    return Float(settings.codeViewTextSize)
                  },
                  set: {
                    settings.codeViewTextSize = Int($0)
                  }), in: 6...30, step: 1)
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
        Divider()
          .padding(EdgeInsets(top: 4, leading: 16, bottom: 0, trailing: 16))
        
        CodeView(theme: settings.codeViewTheme,
                 code: $codeBlock,
                 mode: .constant(CodeMode.swift.mode()),
                 fontSize: settings.codeViewTextSize,
                 showInvisibleCharacters: settings.codeViewShowInvisibleCharacters,
                 isReadOnly: true)
          .frame(maxWidth: .infinity, maxHeight: 150)
          .padding(EdgeInsets(top: 16, leading: 32, bottom: 0, trailing: 32))
        
        Spacer()
        
        HStack {
          Spacer()
          Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.3)) { () -> () in
              viewModel.isVisible = false
            }
          }) {
            Text(NSLocalizedString("Close", comment: ""))
              .foregroundColor(.white)
              .frame(width: 50)
              .padding(8)
              .background(Color.transparent)
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
      .background(themePrimaryColor)
      .cornerRadius(4.0)
      .offset(x: 0,
              y: viewModel.isVisible ? (( viewModel.size.height / 2) - ((viewModel.size.height / 1.5) / 1.5)) : 10000)
      .transition(AnyTransition.move(edge: .bottom))
      
    }
  }
  
  var backgroundView: some View {
    viewModel.isVisible ? themeShadowColor : Color.clear
  }
}

final class SettingsViewModel: ObservableObject {
  
  @Binding var isVisible: Bool
  var size: CGSize
  
  init(isVisible: Binding<Bool>, readerSize: CGSize) {
    self._isVisible = isVisible
    self.size = readerSize
  }
  
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView(viewModel: SettingsViewModel(isVisible: .constant(true),
                                              readerSize: CGSize(width: 400,height: 300)))
  }
}

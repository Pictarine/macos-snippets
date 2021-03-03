//
//  SettingsView.swift
//  Snip
//
//  Created by Anthony Fernandez on 9/7/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI
import Combine

struct SettingsView: View {
  
  @EnvironmentObject var settings: Settings
  
  @Environment(\.themePrimaryColor) var themePrimaryColor
  @Environment(\.themeTextColor) var themeTextColor
  @Environment(\.themeShadowColor) var themeShadowColor
  
  @ObservedObject var viewModel: SettingsViewModel
  
  @State private var selectedTheme = 0
  @State private var selectedAppTheme = 0
  
  var body: some View {
    VStack(alignment: .leading) {
      
      HStack {
        Text(NSLocalizedString("Settings", comment: ""))
          .font(.largeTitle)
          .foregroundColor(themeTextColor)
        Spacer()
      }
      .padding(16)
      
      HStack {
        Text(NSLocalizedString("App_Theme", comment: ""))
        .foregroundColor(themeTextColor)
        Spacer()
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
                  EmptyView()
        ) {
          ForEach(0 ..< SnipAppTheme.allCases.count) { index in
            Text(SnipAppTheme.allCases[index].rawValue).tag(index)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(width: 200)
      }
      .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
      Divider()
        .padding(EdgeInsets(top: 4, leading: 16, bottom: 0, trailing: 16))
      
      Group {
        HStack {
          Text(NSLocalizedString("CD_Theme", comment: ""))
          .foregroundColor(themeTextColor)
          Spacer()
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
                    EmptyView()
          ) {
            ForEach(0 ..< CodeViewTheme.list.count) {
              Text(CodeViewTheme.list[$0].rawValue)
            }
          }
          .pickerStyle(DefaultPickerStyle())
          .frame(width: 200)
        }
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
          .frame(width: 400)
      }
      .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
      Divider()
        .padding(EdgeInsets(top: 4, leading: 16, bottom: 0, trailing: 16))
      
      HStack {
        Spacer()
        
        if let codeViewerModel = viewModel.codeViewerModel {
          CodeView(viewModel: codeViewerModel)
            .frame(maxWidth: 500, maxHeight: 150)
        }
        
        Spacer()
      }
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
        .onHover { inside in
          if inside {
            NSCursor.pointingHand.push()
          } else {
            NSCursor.pop()
          }
        }
        Spacer()
      }
      .padding(8)
    }
    .background(themePrimaryColor)
    .cornerRadius(4.0)
  }
  
}

final class SettingsViewModel: ObservableObject {
  
  @Binding var isVisible: Bool
  
  var codeViewerModel: CodeViewerModel?
  
  init(isVisible: Binding<Bool>) {
    self._isVisible = isVisible
    
    let snipItem = SnipItem.file(name: "Test")
    snipItem.snippet = try! String(contentsOf: Bundle.main.url(forResource: "Demo", withExtension: "txt")!)
    snipItem.mode = CodeMode.swift.mode()

    codeViewerModel = CodeViewerModel(snipItem: Just(snipItem).eraseToAnyPublisher(),
                                      isReadOnly: true)
  }
  
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView(viewModel: SettingsViewModel(isVisible: .constant(true)))
  }
}

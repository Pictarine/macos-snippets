//
//  ModeSelectionView.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/30/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct ModeSelectionView: View {
  
  @ObservedObject var viewModel: ModeSelectionViewModel
  @State var selectedModeIndex: Int = 0
  
  private let modesList = CodeMode.list()
  
  var body: some View {
    
    HStack {
      
      ForEach(0..<viewModel.tags.count) { tagIndex in
        Text(self.viewModel.tags[tagIndex])
          .padding(4)
          .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.PURPLE_500.opacity(0.7), lineWidth: 1))
          .foregroundColor(Color.PURPLE_500.opacity(0.7))
      }
      
      Spacer()
      
      Picker(selection: Binding<Int>(
        get: {
          let index = self.modesList.firstIndex(where: { (mode) -> Bool in
            mode == self.viewModel.currentMode
          }) ?? -1
          return index
      },
        set: {
          self.selectedModeIndex = $0
          self.viewModel.currentMode = self.modesList[$0]
      }),
             label: EmptyView()) {
              ForEach(0 ..< modesList.count) {
                Text(self.modesList[$0].name)
              }
      }
      .frame(minWidth: 100, idealWidth: 150, maxWidth: 150, alignment: .leading)
      .pickerStyle(DefaultPickerStyle())
      .buttonStyle(PlainButtonStyle())
      .textFieldStyle(PlainTextFieldStyle())
      
    }
    .padding(.horizontal, 16)
    
  }
}

final class ModeSelectionViewModel: ObservableObject {
  
  @Binding var currentMode: Mode
  @Binding var tags: [String]
  
  init(snippetMode: Binding<Mode>, snippetTags: Binding<[String]>) {
    _currentMode = snippetMode
    _tags = snippetTags
  }
}

struct ModeSelectionView_Previews: PreviewProvider {
  static var previews: some View {
    ModeSelectionView(viewModel: ModeSelectionViewModel(snippetMode: .constant(CodeMode.text.mode()),
                                                        snippetTags: .constant([])))
  }
}

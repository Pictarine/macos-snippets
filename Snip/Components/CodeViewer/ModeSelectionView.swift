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
  @State var newTag: String = ""
  
  private let modesList = CodeMode.list()
  
  var body: some View {
    
    HStack {
      
      tags
      
      addNewTag
      
      Spacer()
      
      codeModeSelector
      
    }
    .padding(.horizontal, 16)
    
  }
  
  var tags: some View {
    ScrollView (.horizontal) {
      HStack {
        ForEach(0..<viewModel.tags.count, id: \.self) { tagIndex in
          TagView(tag: self.viewModel.tags[tagIndex], onRemoveTapped: {
            self.viewModel.tags.remove(at: tagIndex)
            self.viewModel.objectWillChange.send()
          })
        }
      }
    }
    .frame(height: 55)
  }
  
  var addNewTag: some View {
    CustomTextField(placeholder: Text("New Tag").foregroundColor(Color.ORANGE_500.opacity(0.4)),
                    text: $newTag,
                    commit: {
                      
                      guard self.newTag.count > 1 else { return }
                      
                      self.viewModel.tags.append(self.newTag)
                      self.newTag = ""
                      
                      self.viewModel.objectWillChange.send()
    })
      .frame(width: 60)
      .padding(4)
      .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.ORANGE_500.opacity(0.4), lineWidth: 1))
      .textFieldStyle(PlainTextFieldStyle())
  }
  
  var codeModeSelector: some View {
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
            ForEach(0 ..< modesList.count, id: \.self) {
              Text(self.modesList[$0].name)
            }
    }
    .frame(minWidth: 100,
           idealWidth: 150,
           maxWidth: 150,
           alignment: .leading)
    .pickerStyle(DefaultPickerStyle())
    .buttonStyle(PlainButtonStyle())
    .textFieldStyle(PlainTextFieldStyle())
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
                                                        snippetTags: .constant(["hellos"])))
  }
}

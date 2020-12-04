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
  
  @Environment(\.themeTextColor) var themeTextColor
  
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
      HStack(spacing: 8) {
        ForEach(viewModel.tags, id: \.self) { tag in
          TagView(tag: tag, onRemoveTapped: {
            self.viewModel.onTagChange(tag, TagJob.remove)
            //self.viewModel.tags.remove(at: tagIndex)
          })
        }
      }.padding(.leading, 4)
    }
    .frame(height: 55)
  }
  
  var addNewTag: some View {
    CustomTextField(placeholder: Text("New Tag").foregroundColor(themeTextColor.opacity(0.7)),
                    text: $newTag,
                    commit: {
                      print("Commit")
                      guard self.newTag.count > 1 else { return }
                      
                      //self.viewModel.tags.append(self.newTag)
                      self.viewModel.onTagChange(self.newTag, TagJob.add)
                      self.newTag = ""
                      
                      //self.viewModel.objectWillChange.send()
    })
      .frame(width: 60)
      .padding(4)
      .overlay(RoundedRectangle(cornerRadius: 4).stroke(themeTextColor.opacity(0.7), lineWidth: 1))
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
        self.viewModel.currentMode = self.modesList[$0]
        self.viewModel.onModeSelection(self.modesList[$0])
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
  }
  
}

final class ModeSelectionViewModel: ObservableObject {
  
  var currentMode: Mode
  var tags: [String]
  
  var onModeSelection: (Mode) -> ()
  var onTagChange: (String, TagJob) -> ()
  
  init(snippetMode: Mode,
       snippetTags: [String],
       onModeSelection: @escaping (Mode) -> (),
       onTagChange: @escaping (String, TagJob) -> ()) {
    currentMode = snippetMode
    tags = snippetTags
    self.onModeSelection = onModeSelection
    self.onTagChange = onTagChange
    
    print("Refresh mode selection")
  }
}

struct ModeSelectionView_Previews: PreviewProvider {
  static var previews: some View {
    ModeSelectionView(viewModel: ModeSelectionViewModel(snippetMode: CodeMode.text.mode(),
                                                        snippetTags: ["hellos"],
                                                        onModeSelection: { mode in print("action")},
                                                        onTagChange: { _, _ in print("action")}))
  }
}

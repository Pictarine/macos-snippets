//
//  ModeSelectionView.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/30/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI
import Combine

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
          })
        }
      }.padding(.leading, 4)
    }
    .frame(height: 55)
  }
  
  var addNewTag: some View {
    CustomTextField(placeholder: Text(NSLocalizedString("New_Tag", comment: "")).foregroundColor(themeTextColor.opacity(0.7)),
                    text: $newTag,
                    commit: {
                      guard self.newTag.count > 1 else { return }
                      
                      self.viewModel.onTagChange(self.newTag, TagJob.add)
                      self.newTag = ""
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
  
  @Published var currentMode: Mode = CodeMode.text.mode()
  @Published var tags: [String] = []
  
  var onModeSelection: (Mode) -> ()
  var onTagChange: (String, TagJob) -> ()
  
  var cancellable: AnyCancellable?
  
  init(snipItem: AnyPublisher<SnipItem?, Never>,
       onModeSelection: @escaping (Mode) -> (),
       onTagChange: @escaping (String, TagJob) -> ()) {
    self.onModeSelection = onModeSelection
    self.onTagChange = onTagChange
    
    cancellable = snipItem
      .sink { [weak self] (snipItem) in
        guard let this = self,
              let snipItem = snipItem
        else { return }
        
        this.currentMode = snipItem.mode
        this.tags = snipItem.tags
      }
    
    print("Refresh mode selection")
  }
  
  deinit {
    cancellable?.cancel()
  }
}

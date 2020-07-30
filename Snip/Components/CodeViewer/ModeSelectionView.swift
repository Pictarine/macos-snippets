//
//  ModeSelectionView.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/30/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct ModeSelectionView: View {
  
  @State var selectedModeIndex: Int = 0
  @Binding var currentMode: Mode
  
  private let modesList = CodeMode.list()
  var body: some View {
    
    HStack {
      Picker(selection: Binding<Int>(
        get: {
          let index = self.modesList.firstIndex(where: { (mode) -> Bool in
            mode == self.currentMode
          }) ?? -1
          return index
      },
        set: {
          self.selectedModeIndex = $0
          self.currentMode = self.modesList[$0]
      }),
             label: Text("")) {
              ForEach(0 ..< modesList.count) {
                Text(self.modesList[$0].name)
              }
      }
      .frame(minWidth: 100, idealWidth: 150, maxWidth: 150, alignment: .leading)
      .padding(.leading, 8)
      Spacer()
    }
    
    
  }
}

struct ModeSelectionView_Previews: PreviewProvider {
  static var previews: some View {
    ModeSelectionView(currentMode: .constant(CodeMode.text.mode()))
  }
}

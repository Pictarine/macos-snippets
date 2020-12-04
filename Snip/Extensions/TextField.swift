//
//  TextField.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/4/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

extension NSTextField {
  open override var focusRingType: NSFocusRingType {
    get { .none }
    set { }
  }
  
}

struct CustomTextField: View {
  var placeholder: Text
  @Binding var text: String
  var editingChanged: (Bool)->() = { _ in }
  var commit: ()->() = { }
  
  var body: some View {
    ZStack(alignment: .leading) {
      if text.isEmpty { placeholder }
      TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
    }
  }
}

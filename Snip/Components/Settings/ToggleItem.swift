//
//  ToggleItem.swift
//  Snip
//
//  Created by Anthony Fernandez on 10/6/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct ToggleItem: View {
  
  @Binding var option: Bool
  var optionText: String
  
  var body: some View {
    VStack {
      HStack {
        Text(optionText)
          .foregroundColor(.text)
        Spacer()
        Toggle(optionText, isOn: $option)
        .labelsHidden()
        .toggleStyle(SwitchToggleStyle())
      }
      Divider()
    }
    .frame(maxWidth: .infinity)
    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
  }
}

struct ToggleItem_Previews: PreviewProvider {
  static var previews: some View {
    ToggleItem(option: .constant(true), optionText: "Option")
  }
}

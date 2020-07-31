//
//  ImageButton.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/30/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct ImageButton: View {
  
  let imageName: String
  let action: () -> ()
  
  var body: some View {
    Button(action: action) {
      Image(imageName)
        .resizable()
        .frame(width: 20, height: 20, alignment: .center)
        .scaledToFill()
    }
    .buttonStyle(PlainButtonStyle())
  }
}

struct ImageButton_Previews: PreviewProvider {
  static var previews: some View {
    ImageButton(imageName: "ic_delete", action: {
      print("Preview")
    })
  }
}

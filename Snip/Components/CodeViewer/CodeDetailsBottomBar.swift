//
//  CodeDetailsBottomBar.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/30/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct CodeDetailsBottomBar: View {
  
  let code: String
  
  var body: some View {
    HStack {
      Text("\(code.characterCount()) characters")
        .font(Font.custom("CourierNewPSMT", size: 12))
      
      Text("\(code.wordCount()) words")
        .font(Font.custom("CourierNewPSMT", size: 12))
      
      Text("\(code.lineCount()) lines")
        .font(Font.custom("CourierNewPSMT", size: 12))
      
      Spacer()
      
      Button(action: copyToClipboard) {
        Image("ic_clipboard")
          .resizable()
          .frame(width: 15, height: 15, alignment: .center)
          .scaledToFit()
        Text("Copy to clipboard")
      }
      .buttonStyle(PlainButtonStyle())
    }
    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
  }
  
  func copyToClipboard() {
    print("Copy to clipboard")
    let pasteboard = NSPasteboard.general
    pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
    pasteboard.setString(code, forType: NSPasteboard.PasteboardType.string)

  }
}

struct CodeDetailsBottomBar_Previews: PreviewProvider {
  static var previews: some View {
    CodeDetailsBottomBar(code: "")
  }
}

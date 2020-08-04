//
//  CodeDetailsBottomBar.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/30/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct CodeDetailsBottomBar: View {
  
  @ObservedObject var viewModel: CodeDetailsViewModel
  
  var body: some View {
    HStack {
      Text("\(viewModel.code.characterCount()) characters")
        .font(Font.custom("CourierNewPSMT", size: 12))
      
      Text("\(viewModel.code.wordCount()) words")
        .font(Font.custom("CourierNewPSMT", size: 12))
      
      Text("\(viewModel.code.lineCount()) lines")
        .font(Font.custom("CourierNewPSMT", size: 12))
      
      Spacer()
      
      Button(action: { self.viewModel.copyToClipboard() }) {
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
  
}

final class CodeDetailsViewModel: ObservableObject {
  
  @Binding var code: String
  
  init(snippetCode: Binding<String>) {
    _code = snippetCode
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
    CodeDetailsBottomBar(viewModel: CodeDetailsViewModel(snippetCode: .constant("")))
  }
}

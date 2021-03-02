//
//  CodeDetailsBottomBar.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/30/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI
import Combine

struct CodeDetailsBottomBar: View {
  
  @ObservedObject var viewModel: CodeDetailsViewModel
  
  @Environment(\.themeTextColor) var themeTextColor
  
  var body: some View {
    HStack {
      Text("\(viewModel.code.characterCount()) \(NSLocalizedString("Char", comment: ""))")
        .font(Font.custom("CourierNewPSMT", size: 12))
        .foregroundColor(themeTextColor)
      
      Text("\(viewModel.code.wordCount()) \(NSLocalizedString("Words", comment: ""))")
        .font(Font.custom("CourierNewPSMT", size: 12))
        .foregroundColor(themeTextColor)
      
      Text("\(viewModel.code.lineCount()) \(NSLocalizedString("Lines", comment: ""))")
        .font(Font.custom("CourierNewPSMT", size: 12))
        .foregroundColor(themeTextColor)
      
      Spacer()
      
      Button(action: { self.viewModel.copyToClipboard() }) {
        Image("ic_clipboard")
          .resizable()
          .renderingMode(.original)
          .colorMultiply(themeTextColor)
          .frame(width: 15,
                 height: 15,
                 alignment: .center)
          .scaledToFit()
        Text(NSLocalizedString("Copy_Clipboard", comment: ""))
        .foregroundColor(themeTextColor)
      }
      .buttonStyle(PlainButtonStyle())
    }
    .padding(EdgeInsets(top: 8,
                        leading: 16,
                        bottom: 8,
                        trailing: 16))
  }
  
}

final class CodeDetailsViewModel: ObservableObject {
  
  @Published var code: String = ""
  
  var cancellable: AnyCancellable?
  
  init(snipItem: AnyPublisher<SnipItem?, Never>) {
    cancellable = snipItem
      .sink { [weak self] (snipItem) in
        guard let this = self,
              let snipItem = snipItem
        else { return }
        this.code = snipItem.snippet
      }
  }
  
  func copyToClipboard() {
    let pasteboard = NSPasteboard.general
    pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
    pasteboard.setString(code, forType: NSPasteboard.PasteboardType.string)
  }
  
  deinit {
    cancellable?.cancel()
  }
}

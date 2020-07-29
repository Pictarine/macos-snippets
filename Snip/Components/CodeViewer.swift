//
//  CodeViewer.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct CodeViewer: View {
  
  @State var mimeType = "application/json"
  @State var content = try! String(contentsOf: Bundle.main.url(forResource: "data", withExtension: "json")!)
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack{
        Text("Curry Func")
          .font(Font.custom("HelveticaNeue", size: 20))
          .foregroundColor(.white)
      }.padding()
      
      
      CodeView(code: $content, mimeType: $mimeType)
        .frame(minWidth: 300, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
      
      Divider()
      HStack {
        Text("150 characters")
          .font(Font.custom("CourierNewPSMT", size: 12))
        
        Text("29 words")
        .font(Font.custom("CourierNewPSMT", size: 12))
        
        Text("24 lines")
        .font(Font.custom("CourierNewPSMT", size: 12))
        
        Spacer()
        
        Button(action: copyToClipboard) {
          Text("Copy to clipboard")
        }
        .buttonStyle(PlainButtonStyle())
      }
      .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    .background(Color.BLACK_500)
    .listStyle(PlainListStyle())
  }
  
  func copyToClipboard() {
    print("Copy to clipboard")
  }
}

struct CodeViewer_Previews: PreviewProvider {
  static var previews: some View {
    CodeViewer()
  }
}

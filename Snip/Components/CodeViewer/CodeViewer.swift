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
  @State var code = try! String(contentsOf: Bundle.main.url(forResource: "data", withExtension: "json")!)
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack{
        Text("Curry Func")
          .font(Font.custom("HelveticaNeue", size: 20))
          .foregroundColor(.white)
      }.padding()
      
      
      CodeView(code: $code, mimeType: $mimeType)
        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
      
      Divider()
      
      CodeDetailsBottomBar(code: code)
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    .background(Color.BLACK_500)
    .listStyle(PlainListStyle())
  }
  
  
}

struct CodeViewer_Previews: PreviewProvider {
  static var previews: some View {
    CodeViewer()
  }
}

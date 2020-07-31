//
//  CodeActionsTopBar.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/30/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct CodeActionsTopBar: View {
  
  var body: some View {
    HStack{
      Text("Curry Func")
        .font(Font.custom("HelveticaNeue", size: 20))
        .foregroundColor(.white)
      
      Spacer()
      
      ImageButton(imageName: "ic_fav", action: addToFavorites)
      ImageButton(imageName: "ic_delete", action: delete)
      
    }.padding()
  }
  
  func delete() {
    print("delete")
  }
  
  func addToFavorites() {
    print("addToFavorites")
  }
}

struct CodeActionsTopBar_Previews: PreviewProvider {
  static var previews: some View {
    CodeActionsTopBar()
  }
}

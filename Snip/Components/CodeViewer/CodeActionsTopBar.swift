//
//  CodeActionsTopBar.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/30/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct CodeActionsTopBar: View {
  
  @ObservedObject var viewModel: CodeActionsViewModel
  
  var body: some View {
    HStack{
      Text(viewModel.snipName)
        .font(Font.custom("HelveticaNeue", size: 20))
        .foregroundColor(.white)
      
      Spacer()
      
      ImageButton(imageName: viewModel.isSnipFavorite ? "ic_fav_selected" : "ic_fav", action: viewModel.addToFavorites)
      ImageButton(imageName: "ic_delete", action: viewModel.delete)
      ImageButton(imageName: "ic_share", action: viewModel.share)
      
    }
    .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
  }
  
}

final class CodeActionsViewModel: ObservableObject {
  
  @Binding var snipName: String
  @Binding var isSnipFavorite: Bool
  
  init(name: Binding<String>, isFavorite: Binding<Bool>) {
    _snipName = name
    _isSnipFavorite = isFavorite
  }
  
  func delete() {
    print("delete")
  }
  
  func share() {
    print("share")
  }
  
  func addToFavorites() {
    isSnipFavorite.toggle()
  }
  
}

struct CodeActionsTopBar_Previews: PreviewProvider {
  static var previews: some View {
    CodeActionsTopBar(viewModel: CodeActionsViewModel(name: .constant("Curry func"),
                                                      isFavorite: .constant(true))
    )
  }
}

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
  @State var showSharingActions = false
  
  var body: some View {
    HStack{
      TextField("Snippet name", text: Binding<String>(get: {
        self.viewModel.snipName
      }, set: {
        self.viewModel.snipName = $0
        self.viewModel.onRename($0)
      })
      )
        .font(Font.custom("HelveticaNeue", size: 20))
        .foregroundColor(.white)
        .frame(maxHeight: .infinity)
        .textFieldStyle(PlainTextFieldStyle())
      
      
      ImageButton(imageName: viewModel.isSnipFavorite ? "ic_fav_selected" : "ic_fav",
                  action: viewModel.onToggleFavorite,
                  content: { EmptyView() })
      ImageButton(imageName: "ic_delete",
                  action: viewModel.onDelete,
                  content: { EmptyView() })
      ImageButton(imageName: "ic_share",
                  action: {
        self.showSharingActions = true
      },
                  content: {
        SharingsPicker(isPresented: self.$showSharingActions, sharingItems: [self.viewModel.snipCode])
      })
      
    }
    .background(Color.BLACK_200.opacity(0.4))
    .frame(height: 40)
    .padding(EdgeInsets(top: 16,
                        leading: 16,
                        bottom: 0,
                        trailing: 16))
  }
  
}

final class CodeActionsViewModel: ObservableObject {
  
  var snipName: String
  var isSnipFavorite: Bool
  var snipCode: String
  
  var onRename: (String) -> Void
  var onToggleFavorite: () -> Void
  var onDelete: () -> Void
  
  init(name: String,
       code: String,
       isFavorite: Bool,
       onRename: @escaping (String) -> Void,
       onToggleFavorite: @escaping () -> Void,
       onDelete: @escaping () -> Void) {
    
    snipName = name
    snipCode = code
    isSnipFavorite = isFavorite
    self.onRename = onRename
    self.onToggleFavorite = onToggleFavorite
    self.onDelete = onDelete
  }
  
}

struct CodeActionsTopBar_Previews: PreviewProvider {
  static var previews: some View {
    CodeActionsTopBar(viewModel: CodeActionsViewModel(name: "Curry func",
                                                      code: "Hello",
                                                      isFavorite: true,
                                                      onRename: { _ in print("action")},
                                                      onToggleFavorite: {},
                                                      onDelete: {})
    )
  }
}

//
//  CodeActionsTopBar.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/30/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct CodeActionsTopBar: View {
  
  @ObservedObject var syncManager = SyncManager.shared
  @ObservedObject var viewModel: CodeActionsViewModel
  @State private var showSharingActions = false
  @State private var showInfos = false
  @State private var moveRightLeft = false
  @State private var isPreviewEnabled = false
  
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
        .foregroundColor(.text)
        .frame(maxHeight: .infinity)
        .textFieldStyle(PlainTextFieldStyle())
      
      if syncManager.isAuthenticated {
        ZStack {
          if viewModel.syncState == .syncing {
            ZStack {
              Circle()
                .trim(from: 1/4, to: 1)
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.accent)
                .frame(width: 20, height: 20)
                .rotationEffect(.degrees(moveRightLeft ? 360 : 0))
                .animation(Animation.easeOut(duration: 1).repeatForever(autoreverses: false))
                .onAppear() {
                  self.moveRightLeft.toggle()
              }
            }
          }
          else {
            ImageButton(imageName: viewModel.syncState == .local ? "ic_sync" : "ic_synced",
                        action: viewModel.onUpload,
                        content: { EmptyView() })
              .overlay(
                Circle()
                  .fill(viewModel.syncState == .local ? Color.RED_500 : Color.green)
                  .frame(width: 8, height: 8)
                  .offset(x: 7, y: 6)
            )
          }
          
        }
      }
      
      if viewModel.remoteURL != nil {
        ImageButton(imageName: "ic_open",
                    action: viewModel.openRemoteURL,
                    content: { EmptyView() })
      }
      
      if viewModel.onPreviewToggle != nil {
        ImageButton(imageName: isPreviewEnabled ? "ic_preview_hide" : "ic_preview_show",
                    action: {
                      self.viewModel.onPreviewToggle?()
                      
                      DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        self.isPreviewEnabled.toggle()
                      }
        },
                    content: { EmptyView() })
      }
      
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
                    SharingsPicker(isPresented: self.$showSharingActions, sharingItems: ["\(self.viewModel.snipCode) \n\n - Shared via Snip https://cutt.ly/snip"])
      })
      ImageButton(imageName: "ic_info",
                  action: { self.showInfos.toggle() },
                  content: { EmptyView() })
        .popover(
          isPresented: self.$showInfos,
          arrowEdge: .bottom
        ) {
          VStack {
            Text("Snip Infos")
              .font(.headline)
            Text("Size of \(self.viewModel.snipCode.size())")
              .padding(.top, 16)
            Text("Last updated \(self.viewModel.snipLastUpdate.dateAndTimetoString())")
              .padding(.top)
          }.padding(16)
      }
      
    }
    .background(Color.secondary.opacity(0.4))
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
  var snipLastUpdate: Date
  var syncState: SnipItem.SyncState
  var remoteURL: String?
  
  var onRename: (String) -> Void
  var onToggleFavorite: () -> Void
  var onDelete: () -> Void
  var onUpload: () -> Void
  var onPreviewToggle: (() -> Void)?
  
  init(name: String,
       code: String,
       isFavorite: Bool,
       lastUpdate: Date,
       syncState: SnipItem.SyncState,
       remoteURL: String?,
       onRename: @escaping (String) -> Void,
       onToggleFavorite: @escaping () -> Void,
       onDelete: @escaping () -> Void,
       onUpload: @escaping () -> Void,
       onPreviewToggle: (() -> Void)?) {
    
    self.snipName = name
    self.snipCode = code
    self.isSnipFavorite = isFavorite
    self.snipLastUpdate = lastUpdate
    self.syncState = syncState
    self.remoteURL = remoteURL
    self.onRename = onRename
    self.onToggleFavorite = onToggleFavorite
    self.onDelete = onDelete
    self.onUpload = onUpload
    self.onPreviewToggle = onPreviewToggle
  }
  
  func openRemoteURL() {
    guard let sourceURL = remoteURL,
      let url = URL(string: sourceURL) else { return }
    NSWorkspace.shared.open(url)
  }
}

struct CodeActionsTopBar_Previews: PreviewProvider {
  static var previews: some View {
    CodeActionsTopBar(viewModel: CodeActionsViewModel(name: "Curry func",
                                                      code: "Hello",
                                                      isFavorite: true,
                                                      lastUpdate: Date(),
                                                      syncState: .syncing,
                                                      remoteURL: nil,
                                                      onRename: { _ in print("action")},
                                                      onToggleFavorite: {},
                                                      onDelete: {},
                                                      onUpload: {},
                                                      onPreviewToggle: {})
    )
  }
}

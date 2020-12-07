//
//  CodeActionsTopBar.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/30/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct CodeActionsTopBar: View {
  
  @EnvironmentObject var settings: Settings
  
  @Environment(\.themeSecondaryColor) var themeSecondaryColor
  @Environment(\.themeTextColor) var themeTextColor
  
  @ObservedObject var syncManager = SyncManager.shared
  @ObservedObject var viewModel: CodeActionsViewModel
  
  @State private var showInfos = false
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
      .foregroundColor(themeTextColor)
      .frame(maxHeight: .infinity)
      .padding(.leading, 8)
      .textFieldStyle(PlainTextFieldStyle())
    }
    .background(themeSecondaryColor.opacity(0.4))
    .frame(height: 40)
    .padding(EdgeInsets(top: 16,
                        leading: 16,
                        bottom: 0,
                        trailing: 16))
    .toolbar {
      ToolbarItem(placement: .navigation) {
        Button(action: viewModel.toggleSidebar) {
          Image(systemName: "sidebar.left")
        }
        .onHover { inside in
          if inside {
            NSCursor.pointingHand.push()
          } else {
            NSCursor.pop()
          }
        }
      }
      
      ToolbarItem(placement: .status) {
        if syncManager.isAuthenticated {
          Button(action: viewModel.onUpload) {
            
            if viewModel.syncState == .syncing {
              ActivityIndicator()
                .frame(width: 15, height: 15, alignment: .center)
                .foregroundColor(.accent)
            }
            else {
              Image(systemName: viewModel.syncState == .local ? "icloud" : "bolt.horizontal.icloud.fill")
            }
            
          }
          .overlay(
            Circle()
              .fill(viewModel.syncStateColor)
              .frame(width: 8, height: 8)
              .offset(x: 7, y: 6)
          )
          .tooltip("Add to Gist")
        }
      }
      
      ToolbarItem(placement: .status) {
        if viewModel.remoteURL != nil {
          Button(action: viewModel.openRemoteURL) {
            Image(systemName: "square.and.arrow.up")
          }
          .tooltip("Open original post")
          .onHover { inside in
            if inside {
              NSCursor.pointingHand.push()
            } else {
              NSCursor.pop()
            }
          }
        }
      }
      
      ToolbarItem(placement: .status) {
        if viewModel.onPreviewToggle != nil {
          Button(action: {
            viewModel.onPreviewToggle?()
            withAnimation(Animation.easeIn(duration: 0.6).delay(0.3)) {
              isPreviewEnabled.toggle()
            }
          }) {
            Image(systemName: isPreviewEnabled ? "eye.fill" : "eye")
          }
          .tooltip("Preview content")
          .onHover { inside in
            if inside {
              NSCursor.pointingHand.push()
            } else {
              NSCursor.pop()
            }
          }
        }
      }
      
      ToolbarItem(placement: .status) {
        Button(action: viewModel.onToggleFavorite) {
          Image(systemName: viewModel.isSnipFavorite ? "bookmark.fill" : "bookmark")
        }
        .tooltip("Add to favorites")
        .onHover { inside in
          if inside {
            NSCursor.pointingHand.push()
          } else {
            NSCursor.pop()
          }
        }
      }
      
      ToolbarItem(placement: .status) {
        Button(action: viewModel.onDelete) {
          Image(systemName: "trash")
        }
        .tooltip("Delete snippet")
        .onHover { inside in
          if inside {
            NSCursor.pointingHand.push()
          } else {
            NSCursor.pop()
          }
        }
      }
      
      ToolbarItem(placement: .status) {
        Button(action: { showInfos.toggle() }) {
          Image(systemName: "info.circle")
        }
        .onHover { inside in
          if inside {
            NSCursor.pointingHand.push()
          } else {
            NSCursor.pop()
          }
        }
        .tooltip("Snippet info")
        .popover(
          isPresented: $showInfos,
          arrowEdge: .bottom
        ) {
          VStack {
            Text("Snip Infos")
              .font(.headline)
            Text("Size of \(viewModel.snipCode.size())")
              .padding(.top, 16)
            Text("Last updated \(viewModel.snipLastUpdate.dateAndTimetoString())")
              .padding(.top)
          }.padding(16)
        }
      }
    }
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
  
  func toggleSidebar() {
    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
  }
  
  var syncStateColor: Color {
    switch syncState {
    case .local:
      return .RED_500
    case .synced:
      return .green
    case .syncing:
      return .ORANGE_500
    }
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

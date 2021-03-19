//
//  CodeActionsTopBar.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/30/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI
import Combine

struct CodeActionsTopBar: View {
  
  @EnvironmentObject var settings: Settings
  
  @Environment(\.themeSecondaryColor) var themeSecondaryColor
  @Environment(\.themeTextColor) var themeTextColor
  
  @ObservedObject var syncManager = SyncManager.shared
  @ObservedObject var viewModel: CodeActionsViewModel
  
  @State private var showInfos = false
  @State private var showDeleteWarning = false
  @State private var isPreviewEnabled = false
  
  var body: some View {
    HStack{
      
      TextField(NSLocalizedString("Placeholder_Snip", comment: ""),
                text: Binding<String>(get: {
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
      ToolbarItem(placement: .status) {
        if syncManager.isAuthenticated {
          Button(action: viewModel.onUpload) {
            
            if viewModel.syncState == .syncing {
              ActivityIndicator()
                .frame(width: 15, height: 15, alignment: .center)
                .foregroundColor(.accentDark)
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
          .help("Add to Gist")
        }
      }
      
      ToolbarItem(placement: .status) {
        if viewModel.remoteURL != nil {
          Button(action: viewModel.openRemoteURL) {
            Image(systemName: "curlybraces.square")
          }
          .help(NSLocalizedString("Open_Post", comment: ""))
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
        if viewModel.snipCode.count > 0 {
          Button(action: viewModel.shareCode) {
            Image(systemName: "square.and.arrow.up")
          }
          .help(NSLocalizedString("Open_Post", comment: ""))
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
        if viewModel.isPreviewAvailable {
          Button(action: {
            viewModel.onPreviewToggle()
            withAnimation(Animation.easeIn(duration: 0.6).delay(0.3)) {
              isPreviewEnabled.toggle()
            }
          }) {
            Image(systemName: isPreviewEnabled ? "eye.fill" : "eye")
          }
          .keyboardShortcut("p", modifiers: [.command])
          .help("\(NSLocalizedString("Preview", comment: "")), Cmd+P")
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
        .keyboardShortcut("f", modifiers: [.command, .shift])
        .help("\(NSLocalizedString("Add_Fav", comment: "")), Cmd+Shift+F")
        .onHover { inside in
          if inside {
            NSCursor.pointingHand.push()
          } else {
            NSCursor.pop()
          }
        }
      }
      
      ToolbarItem(placement: .status) {
        Button(action: { showDeleteWarning.toggle() }) {
          Image(systemName: "trash")
        }
        .keyboardShortcut("r", modifiers: [.command, .shift])
        .help("\(NSLocalizedString("Delete_Snip", comment: "")), Cmd+Shift+R")
        .onHover { inside in
          if inside {
            NSCursor.pointingHand.push()
          } else {
            NSCursor.pop()
          }
        }
        .alert(isPresented: $showDeleteWarning) {
          Alert(title: Text(NSLocalizedString("Psst", comment: "")),
                message: Text(NSLocalizedString("Delete_Desc", comment: "")),
                primaryButton: .default(Text(NSLocalizedString("Yes", comment: "").uppercased()), action: viewModel.onDelete),
                secondaryButton: .cancel(Text(NSLocalizedString("Cancel", comment: "")))
          )
        }
      }
      
      ToolbarItem(placement: .status) {
        Button(action: { showInfos.toggle() }) {
          Image(systemName: "info.circle")
        }
        .keyboardShortcut("i", modifiers: [.command])
        .onHover { inside in
          if inside {
            NSCursor.pointingHand.push()
          } else {
            NSCursor.pop()
          }
        }
        .help("\(NSLocalizedString("Snip_Infos", comment: "")), Cmd+I")
        .popover(
          isPresented: $showInfos,
          arrowEdge: .bottom
        ) {
          VStack {
            Text(NSLocalizedString("Snip_Infos", comment: ""))
              .font(.headline)
            Text("\(NSLocalizedString("Size", comment: "")) \(viewModel.snipCode.size())")
              .padding(.top, 16)
            Text("\(NSLocalizedString("Last_Update", comment: "")) \(viewModel.snipLastUpdate.dateAndTimetoString())")
              .padding(.top)
          }.padding(16)
        }
      }
    }
  }
  
}

final class CodeActionsViewModel: ObservableObject {
  
  @Published var snipName: String = ""
  @Published var isSnipFavorite: Bool = false
  @Published var snipCode: String = ""
  @Published var snipLastUpdate: Date = Date()
  @Published var syncState: SnipItem.SyncState = .local
  @Published var remoteURL: String?
  @Published var isPreviewAvailable: Bool = false
  
  var snipMode: String = "text"
  
  var onRename: (String) -> Void
  var onToggleFavorite: () -> Void
  var onDelete: () -> Void
  var onUpload: () -> Void
  var onPreviewToggle: () -> Void
  
  var cancellable: AnyCancellable?
  
  init(snipItem: AnyPublisher<SnipItem?, Never>,
       onRename: @escaping (String) -> Void,
       onToggleFavorite: @escaping () -> Void,
       onDelete: @escaping () -> Void,
       onUpload: @escaping () -> Void,
       onPreviewToggle: @escaping () -> Void) {
    
    self.onRename = onRename
    self.onToggleFavorite = onToggleFavorite
    self.onDelete = onDelete
    self.onUpload = onUpload
    self.onPreviewToggle = onPreviewToggle
    
    cancellable = snipItem
      .sink { [weak self] (snipItem) in
        guard let this = self,
              let snipItem = snipItem
        else { return }
        
        this.snipName = snipItem.name
        this.snipCode = snipItem.snippet
        this.isSnipFavorite = snipItem.isFavorite
        this.snipLastUpdate = snipItem.lastUpdateDate
        this.syncState = snipItem.syncState ?? .local
        this.remoteURL = snipItem.remoteURL
        this.snipMode = snipItem.mode.name
        this.isPreviewAvailable = snipItem.mode == CodeMode.html.mode() || snipItem.mode == CodeMode.markdown.mode()
      }
  }
  
  deinit {
    cancellable?.cancel()
  }
  
  func openRemoteURL() {
    guard let sourceURL = remoteURL,
          let url = URL(string: sourceURL) else { return }
    NSWorkspace.shared.open(url)
  }
  
  func shareCode() {
    let baseURL = "https://carbon.now.sh/?bg=rgba%28171%2C+184%2C+195%2C+1%29&t=blackboard&wt=none&l=\(snipMode)&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=true&pv=56px&ph=56px&ln=false&fl=1&fm=Hack&fs=14px&lh=133%25&si=false&es=2x&wm=false&code="
    
    if let escapedCode = snipCode.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed),
       let doubleEscapedCode = escapedCode.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed),
       let carbonURL = URL(string: "\(baseURL)\(doubleEscapedCode)") {
      NSWorkspace.shared.open(carbonURL)
    }
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


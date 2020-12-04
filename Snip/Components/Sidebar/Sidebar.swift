//
//  Sidebar.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct Sidebar: View {
  
  @EnvironmentObject var settings: Settings
  
  @Environment(\.themeTextColor) var themeTextColor
  
  @ObservedObject var syncManager = SyncManager.shared
  @ObservedObject var viewModel: SideBarViewModel
  
  @State private var showingLogoutAlert = false
  
  var body: some View {
    VStack(alignment: .leading) {
      
      addElementView
      
      List() {
        
        favorites
        
        local
        
        //tags
      }
      .listStyle(SidebarListStyle())
      .padding(.top, 16)
      
      HStack {
        ImageButton(imageName: "ic_settings", action: {
          withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.3)) { () -> () in
            settings.isSettingsOpened.toggle()
          }
        }, content: { EmptyView() })
        .tooltip("Settings")
        Spacer()
        
        Text(syncManager.connectedUser?.login ?? "")
          .foregroundColor(themeTextColor)
        
        Button(action: {
          if self.syncManager.isAuthenticated {
            self.showingLogoutAlert = true
          }
          else {
            NSWorkspace.shared.open(SyncManager.oauthURL)
          }
        }) {
          Image(syncManager.isAuthenticated ? "ic_github_connected" : "ic_github")
            .resizable()
            .renderingMode(.original)
            .colorMultiply(themeTextColor)
            .scaledToFit()
            .frame(width: 20, height: 20, alignment: .center)
            .overlay(
              Circle()
                .fill(syncManager.isAuthenticated ? Color.green : Color.RED_500)
                .frame(width: 8, height: 8)
                .offset(x: 8, y: 8)
            )
          
        }
        .tooltip("Connect to Gist from GitHub")
        .alert(isPresented: $showingLogoutAlert) {
          Alert(title: Text("Logout from Github"),
                message: Text("Are you sure about that?"),
                primaryButton: .default(Text("YES"), action: {
                  self.syncManager.logout()
                }),
                secondaryButton: .cancel(Text("Cancel"))
          )
        }
        .buttonStyle(PlainButtonStyle())
      }
      .padding()
    }
    .background(Color.clear)
    .environment(\.defaultMinListRowHeight, 36)
  }
  
  var addElementView: some View {
    ZStack {
      
      // Logo
      HStack{
        Spacer()
        Image("snip")
          .resizable()
          .frame(width: 16, height: 16, alignment: .center)
        Spacer()
      }
      
      // Action
      HStack {
        Spacer()
        MenuButton(label:
                    Text("+")
                    .foregroundColor(.text)
                    .font(.system(size: 22))
        ) {
          Button(action: {
            self.viewModel.onTrigger(.addSnippet(id: nil))
          }) {
            Text("New snippet")
              .font(.system(size: 14))
              .foregroundColor(Color.text)
          }
          Button(action: {
            self.viewModel.onTrigger(.addFolder())
          }) {
            Text("New folder")
              .font(.system(size: 14))
              .foregroundColor(Color.text)
          }
        }
        .menuButtonStyle(BorderlessButtonMenuButtonStyle())
        .foregroundColor(.text)
        .padding(.horizontal, 16)
        .frame(maxWidth: 50, alignment: .center)
        .background(Color.transparent)
      }
    }
  }
  
  @ViewBuilder
  var favorites: some View {
    Section(header:
              Text("Favorites")
              .font(Font.custom("AppleSDGothicNeo-SemiBold", size: 13.0))
              .foregroundColor(themeTextColor.opacity(0.6))
              .padding(.bottom, 8)
              .padding(.top, 16)
    ) {
      
      OutlineGroup(viewModel.filterSnippets(filter: .favorites), id: \.id, children: \.content) {
        SnipItemView(viewModel: SnipItemViewModel(snip: $0,
                                                  activeFilter: .favorites,
                                                  onTrigger: viewModel.onTrigger,
                                                  onSnippetSelection: viewModel.onSnippetSelection))
      }
      
    }
  }
  
  @ViewBuilder
  var local: some View {
    Section(header:
              Text("Local")
              .font(Font.custom("AppleSDGothicNeo-SemiBold", size: 13.0))
              .foregroundColor(themeTextColor.opacity(0.6))
              .padding(.bottom, 8)
              .padding(.top, 16)
    ) {
      
      OutlineGroup(viewModel.filterSnippets(filter: .all), id: \.id, children: \.content) {
        SnipItemView(viewModel: SnipItemViewModel(snip: $0,
                                                  activeFilter: .all,
                                                  onTrigger: viewModel.onTrigger,
                                                  onSnippetSelection: viewModel.onSnippetSelection))
      }
      
    }
    
  }
  
  /*@ViewBuilder
   var tags: some View {
   Text("Tags")
   .font(Font.custom("AppleSDGothicNeo-SemiBold", size: 13.0))
   .foregroundColor(Color.white.opacity(0.6))
   .padding(.bottom, 3)
   .padding(.top, 16)
   
   
   SnipItemsList(viewModel: SnipItemsListModel(snips: viewModel.snippets,
   applyFilter: .tag(tagTitle: "modal"),
   onTrigger: viewModel.trigger(action:)))
   }*/
  
}


final class SideBarViewModel: ObservableObject {
  
  var snippets: [SnipItem]
  
  var onTrigger: (SnipItemsListAction) -> Void
  var onSnippetSelection: (SnipItem, ModelFilter) -> Void
  
  init(snipppets: [SnipItem],
       onTrigger: @escaping (SnipItemsListAction) -> Void,
       onSnippetSelection: @escaping (SnipItem, ModelFilter) -> Void) {
    self.snippets = snipppets
    self.onTrigger = onTrigger
    self.onSnippetSelection = onSnippetSelection
  }
  
  func filterSnippets(filter: ModelFilter) -> [SnipItem] {
    switch filter {
      case .all:
        return snippets
      case .favorites:
        return snippets.allFavorites
      case .tag(let tagTitle):
        return snippets.perTag(tag: tagTitle)
    }
  }
}

//
//  Sidebar.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI
import Combine

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
        .tooltip(NSLocalizedString("Connect_GitHub", comment: ""))
        .alert(isPresented: $showingLogoutAlert) {
          Alert(title: Text(NSLocalizedString("Connect_GitHub", comment: "")),
                message: Text(NSLocalizedString("Validate_Logout_GitHub", comment: "")),
                primaryButton: .default(Text(NSLocalizedString("Yes", comment: "").uppercased()), action: {
                  self.syncManager.logout()
                }),
                secondaryButton: .cancel(Text(NSLocalizedString("Cancel", comment: "")))
          )
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { inside in
          if inside {
            NSCursor.pointingHand.push()
          } else {
            NSCursor.pop()
          }
        }
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
            Text(NSLocalizedString("New_Snippet", comment: ""))
              .font(.system(size: 14))
              .foregroundColor(Color.text)
          }
          Button(action: {
            self.viewModel.onTrigger(.addFolder())
          }) {
            Text(NSLocalizedString("New_Folder", comment: ""))
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
              Text(NSLocalizedString("Favorites", comment: ""))
              .font(Font.custom("AppleSDGothicNeo-SemiBold", size: 13.0))
              .foregroundColor(themeTextColor.opacity(0.6))
              .padding(.bottom, 8)
              .padding(.top, 16)
    ) {
      
      if let favoritesSnippetsViewModel = viewModel.favoritesSnippetsViewModel {
        SnipItemsList(viewModel: favoritesSnippetsViewModel)
      }
      
    }
  }
  
  @ViewBuilder
  var local: some View {
    Section(header:
              Text(NSLocalizedString("Local", comment: ""))
              .font(Font.custom("AppleSDGothicNeo-SemiBold", size: 13.0))
              .foregroundColor(themeTextColor.opacity(0.6))
              .padding(.bottom, 8)
              .padding(.top, 16)
    ) {
      
      if let allSnippetsViewModel = viewModel.allSnippetsViewModel {
        SnipItemsList(viewModel: allSnippetsViewModel)
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
  
  @Published var snippets: [SnipItem] = []
  
  var onTrigger: (SnipItemsListAction) -> Void
  
  var favoritesSnippetsViewModel: SnipItemsListModel?
  var allSnippetsViewModel: SnipItemsListModel?
  
  var cancellable: AnyCancellable?
  
  init(snippets: AnyPublisher<[SnipItem], Never>,
       onTrigger: @escaping (SnipItemsListAction) -> Void,
       onSnippetSelection: @escaping (SnipItem, ModelFilter) -> Void) {
    
    self.onTrigger = onTrigger
    
    cancellable = snippets
      .sink { [weak self] (snippets) in
        guard let this = self else { return }
        this.snippets = snippets
      }
    
    favoritesSnippetsViewModel = SnipItemsListModel(snips: $snippets.eraseToAnyPublisher(),
                                                    applyFilter: .favorites,
                                                    onTrigger: onTrigger,
                                                    onSnippetSelection: onSnippetSelection)
    
    allSnippetsViewModel = SnipItemsListModel(snips: $snippets.eraseToAnyPublisher(),
                                                    applyFilter: .all,
                                                    onTrigger: onTrigger,
                                                    onSnippetSelection: onSnippetSelection)
  }
  
  deinit {
    cancellable?.cancel()
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

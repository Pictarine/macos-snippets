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
  @State var expand = false
  
  var body: some View {
    VStack(alignment: .leading) {
      
      ZStack {
        VStack(alignment: .leading) {
          
          logo
          
          List() {
            
            tags
            
            favorites
            
            local
            
            //tags
          }
          .listStyle(SidebarListStyle())
          .padding(.top, 16)
        }
        
        VStack {
          HStack {
            Spacer()
            
            VStack(alignment: .trailing) {
              Button(action: { self.expand.toggle() }) {
                Text("+")
                  .foregroundColor(.text)
                  .font(.system(size: 22))
              }
              .buttonStyle(PlainButtonStyle())
              .padding(.horizontal, 16)
              .frame(maxWidth: 50, alignment: .center)
              .background(Color.transparent)
              if expand {
                VStack() {
                  Button(action: {
                    self.viewModel.onTrigger(.addSnippet(id: nil))
                  }) {
                    Text(NSLocalizedString("New_Snippet", comment: ""))
                      .font(.system(size: 14))
                      .foregroundColor(Color.text)
                  }
                  .buttonStyle(PlainButtonStyle())
                  .padding(.top, 8)
                  Divider()
                  Button(action: {
                    self.viewModel.onTrigger(.addFolder())
                  }) {
                    Text(NSLocalizedString("New_Folder", comment: ""))
                      .font(.system(size: 14))
                      .foregroundColor(Color.text)
                  }
                  .buttonStyle(PlainButtonStyle())
                  .padding(.bottom, 8)
                }
                .background(Color.BLACK_500.opacity(0.8))
                .frame(width: 100)
                .cornerRadius(6)
              }
            }
          }
          Spacer()
        }
      }
      
      HStack {
        ImageButton(imageName: "ic_settings", action: {
          withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.3)) { () -> () in
            settings.shouldOpenSettings.toggle()
          }
        }, content: { EmptyView() })
        .help("Settings")
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
        .help(NSLocalizedString("Connect_GitHub", comment: ""))
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
  
  var logo: some View {
    HStack{
      Spacer()
      Image("snip")
        .resizable()
        .frame(width: 16, height: 16, alignment: .center)
      Spacer()
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
  
  @ViewBuilder
  var tags: some View {
    Section(header:
              Text(NSLocalizedString("Tags", comment: ""))
              .font(Font.custom("AppleSDGothicNeo-SemiBold", size: 13.0))
              .foregroundColor(themeTextColor.opacity(0.6))
              .padding(.bottom, 8)
              .padding(.top, 16)
    ) {
      
      ForEach(viewModel.snippetsPerTag.keys.sorted(), id: \.self) { key in
        SidebarTagView(viewModel: SidebarTagViewModel(tag: key))
      }
      
    }
  }
  
}


final class SideBarViewModel: ObservableObject {
  
  @Published var snippets: [SnipItem] = []
  @Published var snippetsPerTag: [String: [SnipItem]] = [:]
  
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
        this.snippetsPerTag = [:]
        snippets.flatternSnippets.flatMap{ $0.tags }.forEach { (tag) in
          this.snippetsPerTag[tag] = []
        }
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
}

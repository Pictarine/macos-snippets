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
      List() {
        
        addElementView
        
        favorites
        
        local
        
        //tags
      }
      .removeBackground()
      .padding(.top, 16)
      .background(Color.clear)
      
      HStack {
        ImageButton(imageName: "ic_settings", action: {
          withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.3)) { () -> () in
            settings.isSettingsOpened.toggle()
          }
        }, content: { EmptyView() })
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
    HStack{
      Spacer()
      Image("snip")
        .resizable()
        .frame(width: 15, height: 15, alignment: .center)
      Spacer()
      MenuButton("+") {
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
      }.menuButtonStyle(BorderlessButtonMenuButtonStyle())
        .foregroundColor(.text)
        .font(.system(size: 22))
        .background(Color.clear)
        .frame(maxWidth: 16, alignment: .center)
    }.background(Color.clear)
  }
  
  @ViewBuilder
  var favorites: some View {
    Text("Favorites")
      .font(Font.custom("AppleSDGothicNeo-SemiBold", size: 13.0))
      .foregroundColor(themeTextColor.opacity(0.6))
      .padding(.bottom, 3)
    
    SnipItemsList(viewModel: SnipItemsListModel(snips: viewModel.snippets,
                                                applyFilter: .favorites,
                                                onTrigger: viewModel.onTrigger))
  }
  
  @ViewBuilder
  var local: some View {
    Text("Local")
      .font(Font.custom("AppleSDGothicNeo-SemiBold", size: 13.0))
      .foregroundColor(themeTextColor.opacity(0.6))
      .padding(.bottom, 3)
      .padding(.top, 16)
    
    SnipItemsList(viewModel: SnipItemsListModel(snips: viewModel.snippets,
                                                applyFilter: .all,
                                                onTrigger: viewModel.onTrigger))
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
  
  init(snipppets: [SnipItem], onTrigger: @escaping (SnipItemsListAction) -> Void) {
    self.snippets = snipppets
    self.onTrigger = onTrigger
  }
}


struct Sidebar_Previews: PreviewProvider {
  static var previews: some View {
    Sidebar(viewModel: SideBarViewModel(snipppets: [], onTrigger: {_ in }))
  }
}

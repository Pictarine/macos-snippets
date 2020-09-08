//
//  ContentView.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI
import Combine

struct SnipViewApp: View {
  
  @ObservedObject var snippetManager = SnippetManager.shared
  @ObservedObject var viewModel : SnipViewAppViewModel
  @EnvironmentObject var settings: Settings
  
  var body: some View {
    appNavigation
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  @ViewBuilder
  var appNavigation: some View {
    GeometryReader { reader in
      ZStack {
        NavigationView {
          
          self.sideBar
          self.openingPanel
        }
        self.settingPanel
          .frame(width: reader.size.width, height: reader.size.height)
        self.addExternalSnipPanel
          .frame(width: reader.size.width, height: reader.size.height)
      }
    }
    .edgesIgnoringSafeArea(.top)
  }
  
  var sideBar: some View {
    Sidebar(viewModel: SideBarViewModel(snipppets: viewModel.snippets, onTrigger: viewModel.trigger(action:)))
      //.visualEffect(material: .sidebar)
      .background(Color.secondary)
      .frame(minWidth: 0, idealWidth: 200, maxWidth: 240)
  }
  
  var openingPanel: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        Text("Create your first Snipppet")
          .font(Font.custom("HelveticaNeue-Light", size: 20))
          .foregroundColor(Color.text)
        Spacer()
      }
      HStack {
        Spacer()
        Text("Tips: Cmd+F to search words and regex")
          .font(Font.custom("HelveticaNeue-Light", size: 16))
          .foregroundColor(Color.text)
        Spacer()
      }
      .padding(.top, 8)
      Spacer()
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    .background(Color.primary)
  }
  
  var settingPanel: some View {
    GeometryReader { reader in
      SettingsView(viewModel: SettingsViewModel(readerSize: reader.size))
    }
    .background(self.settings.isSettingsOpened ? Color.black.opacity(0.8) : Color.clear)
    .transition(AnyTransition.opacity)
  }
  
  var addExternalSnipPanel: some View {
    GeometryReader { reader in
      ExternalSnippet(viewModel: ExternalSnippetViewModel(readerSize: reader.size,
                                                          onTrigger: { action in
                                                            self.viewModel.trigger(action:action)
                                                            self.viewModel.resetExternalSnippetAdding()
      },
                                                          onCancel: self.viewModel.resetExternalSnippetAdding),
                      externalSnipItem: self.$snippetManager.tempSnipItem)
    }
    .background(self.snippetManager.hasExternalSnippetQueued ? Color.black.opacity(0.8) : Color.clear)
    .transition(AnyTransition.opacity)
  }
}


final class SnipViewAppViewModel: ObservableObject {
  
  @Published var snippets: [SnipItem] = []
  
  var cancellables: Set<AnyCancellable> = []
  
  init() {
    SnippetManager
      .shared
      .snipets
      .assign(to: \.snippets, on: self)
      .store(in: &cancellables)
  }
  
  func trigger(action: SnipItemsListAction) {
    SnippetManager.shared.trigger(action: action)
  }
  
  func resetExternalSnippetAdding() {
    SnippetManager.shared.hasExternalSnippetQueued = false
    SnippetManager.shared.tempSnipItem = ExternalSnipItem.blank()
  }
}


struct SnipViewApp_Previews: PreviewProvider {
  static var previews: some View {
    SnipViewApp(viewModel: SnipViewAppViewModel())
  }
}

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
  @EnvironmentObject var appState: AppState
  
  var body: some View {
    appNavigation
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  @ViewBuilder
  var appNavigation: some View {
    GeometryReader { reader in
      ZStack {
        NavigationView {
          
          sideBar
          
          if viewModel.selectionSnipItem == nil {
            openingPanel
          }
          else {
            snippetView
          }
          
        }
        welcomePanel
          .frame(width: reader.size.width, height: reader.size.height)
        settingPanel
          .frame(width: reader.size.width, height: reader.size.height)
        addExternalSnipPanel
          .frame(width: reader.size.width, height: reader.size.height)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .environment(\.themePrimaryColor, settings.snipAppTheme == .auto ? .primary : .primaryTheme)
      .environment(\.themeSecondaryColor, settings.snipAppTheme == .auto ? .secondary : .secondaryTheme)
      .environment(\.themeTextColor, settings.snipAppTheme == .auto ? .text : .white)
      .environment(\.themeShadowColor, settings.snipAppTheme == .auto ? .shadow : .shadowTheme)
    }
  }
  
  var sideBar: some View {
    Sidebar(viewModel: SideBarViewModel(snipppets: viewModel.snippets,
                                        onTrigger: viewModel.trigger(action:),
                                        onSnippetSelection: { snipItem, filter in
                                          appState.selectedSnippetId = snipItem.id
                                          appState.selectedSnippetFilter = filter
                                          viewModel.didSelectSnipItem(snipItem)
                                        }))
      //.background(settings.snipAppTheme == .auto ? Color.secondary : Color.secondaryTheme)
      .frame(minWidth: 300)
  }
  
  var snippetView: some View {
    CodeViewer(viewModel: CodeViewerViewModel(onTrigger: viewModel.trigger(action:),
                                              onDimiss: {
                                                appState.selectedSnippetId = nil
                                              }))
      .environmentObject(viewModel.selectionSnipItem!)
  }
  
  var openingPanel: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        Text("Create your first Snipppet")
          .font(Font.custom("HelveticaNeue-Light", size: 20))
          .foregroundColor(settings.snipAppTheme == .auto ? .text : .white)
        Spacer()
      }
      HStack {
        Spacer()
        Text("Tips: Cmd+F to search words and regex")
          .font(Font.custom("HelveticaNeue-Light", size: 16))
          .foregroundColor(settings.snipAppTheme == .auto ? .text : .white)
        Spacer()
      }
      .padding(.top, 8)
      Spacer()
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    .background(settings.snipAppTheme == .auto ? Color.primary : Color.primaryTheme)
  }
  
  var settingPanel: some View {
    GeometryReader { reader in
      SettingsView(viewModel: SettingsViewModel(isVisible: self.$settings.isSettingsOpened, readerSize: reader.size))
    }
  }
  
  var welcomePanel: some View {
    GeometryReader { reader in
      WelcomeView(viewModel: WelcomeViewModel(isVisible: self.$appState.shouldShowChangelogModel, readerSize: reader.size))
    }
  }
  
  var addExternalSnipPanel: some View {
    GeometryReader { reader in
      ExternalSnippet(viewModel: ExternalSnippetViewModel(isVisible: self.snippetManager.hasExternalSnippetQueued,
                                                          readerSize: reader.size,
                                                          onTrigger: { action in
                                                            self.viewModel.trigger(action:action)
                                                            self.viewModel.resetExternalSnippetAdding()
                                                          },
                                                          onCancel: self.viewModel.resetExternalSnippetAdding),
                      externalSnipItem: self.$snippetManager.tempSnipItem)
    }
  }
}


final class SnipViewAppViewModel: ObservableObject {
  
  @Published var snippets: [SnipItem] = []
  @Published var selectionSnipItem: SnipItem?
  
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
  
  func didSelectSnipItem(_ snip: SnipItem) {
    selectionSnipItem = snip
  }
}


struct SnipViewApp_Previews: PreviewProvider {
  static var previews: some View {
    SnipViewApp(viewModel: SnipViewAppViewModel())
  }
}

//
//  ContentView.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI
import Combine

enum ModalView: Identifiable {
    case settings
    case welcome
    case external
    
    var id: Int {
        hashValue
    }
}

struct SnipViewApp: View {
    
    @ObservedObject var viewModel: SnipViewAppViewModel
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var settings: Settings
    
    
    var body: some View {
        appNavigation
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    var appNavigation: some View {
        ZStack {
            NavigationView {
                
                if let sidebarViewModel = viewModel.sidebarViewModel {
                    Sidebar(viewModel: sidebarViewModel)
                        .frame(minWidth: 300)
                }
                
                if let codeViewerViewModel = viewModel.codeViewerViewModel {
                    CodeViewer(viewModel: codeViewerViewModel)
                }
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(\.themePrimaryColor, settings.snipAppTheme == .auto ? .primary : .primaryTheme)
        .environment(\.themeSecondaryColor, settings.snipAppTheme == .auto ? .secondary : .secondaryTheme)
        .environment(\.themeTextColor, settings.snipAppTheme == .auto ? .text : .white)
        .environment(\.themeShadowColor, settings.snipAppTheme == .auto ? .shadow : .shadowTheme)
        .onAppear {
            SyncManager.shared.initialize()
            viewModel.trigger(action: .syncGists())
        }
        .sheet(item: $viewModel.modalView) { content in
            
            switch content {
            case .welcome:
                WelcomeView(viewModel: WelcomeViewModel(isVisible: $appState.shouldOpenWelcome))
                    .frame(width: 800, height: 600)
            case .settings:
                SettingsView(viewModel: SettingsViewModel(isVisible: $settings.shouldOpenSettings))
                    .frame(width: 800, height: 600)
            case .external:
                ExternalSnippet(viewModel: ExternalSnippetViewModel(isVisible: $viewModel.snippetManager.hasExternalSnippetQueued,
                                                                    snipItem: $viewModel.snippetManager.tempSnipItem,
                                                                    onTrigger: viewModel.trigger(action:)))
                    .frame(width: 800, height: 600)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: viewModel.toggleSidebar) {
                    Image(systemName: "sidebar.left")
                }
                .keyboardShortcut(KeyEquivalent.leftArrow, modifiers: [.command])
                .onHover { inside in
                    if inside {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: viewModel.openExtensionLink) {
                    Image(systemName: "square.3.stack.3d.middle.fill")
                }
                .help(NSLocalizedString("Extract_Stack", comment: ""))
                .onHover { inside in
                    if inside {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
            }
        }
        .onOpenURL { url in
            DeepLinkManager.handleDeepLink(url: url)
        }
    }
}


final class SnipViewAppViewModel: ObservableObject {
    
    @Published var snippets: [SnipItem] = []
    @Published var selectionSnipItem: SnipItem?
    @Published var snippetManager = SnippetManager.shared
    @Published var modalView: ModalView?
    
    var appState: AppState
    var settings: Settings
    
    var cancellables: Set<AnyCancellable> = []
    
    var sidebarViewModel: SideBarViewModel?
    var codeViewerViewModel: CodeViewerViewModel?
    
    init(appState: AppState,
         settings: Settings) {
        
        self.appState = appState
        self.settings = settings
        
        SnippetManager
            .shared
            .snipets
            .sink { [weak self] (snippets) in
                guard let this = self else { return }
                this.snippets = snippets
                this.selectionSnipItem = snippets.flatternSnippets.first(where: { $0.id == appState.selectedSnippetId })
            }
            .store(in: &stores)
        
        Publishers.CombineLatest3(settings.$shouldOpenSettings, appState.$shouldOpenWelcome, snippetManager.$hasExternalSnippetQueued)
            .map(triggerModalOpening(openSettings:openWelcome:openExternalSnippet:))
            .sink { [weak self] (modalView) in
                guard let this = self else { return }
                this.modalView = modalView
            }
            .store(in: &stores)
        
        sidebarViewModel = SideBarViewModel(snippets: $snippets.eraseToAnyPublisher(),
                                            onTrigger: trigger(action:),
                                            onSnippetSelection: didSelectSnipItem(_:filter:))
        
        codeViewerViewModel = CodeViewerViewModel(snipItem: $selectionSnipItem.eraseToAnyPublisher(),
                                                  onTrigger: trigger(action:),
                                                  onDimiss: didDeselectSnipItem)
    }
    
    func trigger(action: SnipItemsListAction) {
        SnippetManager.shared.trigger(action: action)
    }
    
    func triggerModalOpening(openSettings: Bool, openWelcome: Bool, openExternalSnippet: Bool) -> ModalView? {
        if openWelcome {
            return .welcome
        }
        else if openSettings {
            return .settings
        }
        else if openExternalSnippet {
            return .external
        }
        else {
            return nil
        }
    }
    
    func didSelectSnipItem(_ snip: SnipItem, filter: ModelFilter) {
        appState.selectedSnippetId = snip.id
        appState.selectedSnippetFilter = filter
        selectionSnipItem = snip
    }
    
    func didDeselectSnipItem() {
        appState.selectedSnippetId = nil
        selectionSnipItem = nil
    }
    
    func openExtensionLink() {
        guard let url = URL(string: "https://cutt.ly/whQTNO3") else { return }
        NSWorkspace.shared.open(url)
    }
    
    func toggleSidebar() {
      NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

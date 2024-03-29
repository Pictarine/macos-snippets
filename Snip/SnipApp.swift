//
//  SnipApp.swift
//  Snip
//
//  Created by Anthony Fernandez on 12/4/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

@main
struct SnipApp: App {
  
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  var viewModel: SnipViewAppViewModel
  
  init() {
    viewModel = SnipViewAppViewModel(appState: AppState(),
                                     settings: Settings())
  }
  
  @SceneBuilder
  var body: some Scene {
    WindowGroup {
      SnipViewApp(viewModel: viewModel)
        .environmentObject(viewModel.appState)
        .environmentObject(viewModel.settings)
        .frame(minWidth: 700,
               idealWidth: 1000,
               maxWidth: .infinity,
               minHeight: 500,
               idealHeight: 600,
               maxHeight: .infinity)
        .handlesExternalEvents(preferring: ["snip"], allowing: ["snip"])
    }
    
  }
}

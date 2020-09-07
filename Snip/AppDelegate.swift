//
//  AppDelegate.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Cocoa
import SwiftUI
import Combine

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  lazy var windows = NSWindow()
  var window: NSWindow!
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    
    SyncManager.shared.initialize()
    
    createWindow()
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
  }
  
  func application(_ application: NSApplication, open urls: [URL]) {
    
    // Bring app in front
    NSApp.activate(ignoringOtherApps: true)
    
    // Handle deeplinks
    DeepLinkManager.handleDeepLink(urls: urls)
  }
  
  
  // Window
  
  func createWindow() {
    
    let snipAppView = SnipViewApp(viewModel: SnipViewAppViewModel())
      .environmentObject(Settings())
      .environmentObject(AppState())
      .edgesIgnoringSafeArea(.top)
      .frame(minWidth: 700,
             maxWidth: .infinity,
             minHeight: 500,
             maxHeight: .infinity)
    
    window = NSWindow(
      contentRect: NSRect(x: 0,
                          y: 0,
                          width: 1000,
                          height: 700),
      styleMask: [.unifiedTitleAndToolbar,
                  .texturedBackground,
                  .fullSizeContentView,
                  .titled, .closable,
                  .miniaturizable,
                  .resizable,
                  .texturedBackground],
      backing: .buffered,
      defer: false)
    window.titleVisibility = .hidden
    window.titlebarAppearsTransparent = true
    window.toolbar?.isVisible = false
    window.isMovableByWindowBackground = true
    window.center()
    window.setFrameAutosaveName("Main Window")
    window.contentView = NSHostingView(rootView: snipAppView)
    window.isReleasedWhenClosed = false
    DispatchQueue.main.async {
      self.window.orderOut(nil)
      self.window.makeKeyAndOrderFront(nil)
    }
  }
  
  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if !flag {
      sender.windows.forEach { $0.makeKeyAndOrderFront(self) }
    }
    return true
  }
  
  
  // Menu
  
  @IBAction func newWindow(_ sender: Any) {
    window.makeKeyAndOrderFront(self)
  }
}


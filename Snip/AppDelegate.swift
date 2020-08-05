//
//  AppDelegate.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  var window: NSWindow!
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    
    let contentView = SnipViewApp()
      .environmentObject(Settings())
      .edgesIgnoringSafeArea(.top)
      .frame(minWidth: 600, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
    
    window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 1000, height: 700),
      styleMask: [.unifiedTitleAndToolbar, .texturedBackground, .fullSizeContentView, .titled, .closable, .miniaturizable, .resizable, .texturedBackground],
      backing: .buffered, defer: false)
    window.titleVisibility = .hidden
    window.titlebarAppearsTransparent = true
    window.toolbar?.isVisible = false
    window.isMovableByWindowBackground = true
    window.center()
    window.setFrameAutosaveName("Main Window")
    window.contentView = NSHostingView(rootView: contentView)
    DispatchQueue.main.async {
      self.window.orderOut(nil)
      self.window.makeKeyAndOrderFront(nil)
    }
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
  }
  
  
}


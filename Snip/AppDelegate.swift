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

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
  
  var window: NSWindow!
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    
    SyncManager.shared.initialize()
    
    //createWindow()
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
  }
  
  func application(_ application: NSApplication, open urls: [URL]) {
    
    // Bring app in front
    NSApp.activate(ignoringOtherApps: true)
    
    // Handle deeplinks
    DeepLinkManager.handleDeepLink(urls: urls)
  }
  
}


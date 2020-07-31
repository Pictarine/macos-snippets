//
//  CodeView.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import SwiftUI
import WebKit


struct CodeView: NSViewRepresentable {
  
  @EnvironmentObject var settings: Settings
  
  @Binding var code: String
  @Binding var mode: Mode
  
  var onLoadSuccess: (() -> ())? = nil
  var onLoadFail: ((Error) -> ())? = nil
  var onContentChange: ((String) -> ())? = nil
  
  func makeNSView(context: Context) -> WKWebView {
    
    let preferences = WKPreferences()
    preferences.javaScriptEnabled = true
    
    let userController = WKUserContentController()
    userController.add(context.coordinator, name: CodeMirrorViewConstants.codeMirrorDidReady)
    userController.add(context.coordinator, name: CodeMirrorViewConstants.codeMirrorTextContentDidChange)
    
    let configuration = WKWebViewConfiguration()
    configuration.preferences = preferences
    configuration.userContentController = userController
    
    let webView = WKWebView(frame: .zero, configuration: configuration)
    webView.navigationDelegate = context.coordinator
    webView.setValue(false, forKey: "drawsBackground")
    
    webView.allowsMagnification = false

    // Load CodeMirror bundle
    guard let bundlePath = Bundle.main.path(forResource: "CodeMirrorView", ofType: "bundle"),
        let bundle = Bundle(path: bundlePath),
        let indexPath = bundle.path(forResource: "index", ofType: "html") else {
            fatalError("CodeMirrorBundle is missing")
    }
    let data = try! Data(contentsOf: URL(fileURLWithPath: indexPath))
    webView.load(data, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: bundle.resourceURL!)
    
    context.coordinator.setThemeName(settings.codeMirrorTheme)
    context.coordinator.setTabInsertsSpaces(true)
    context.coordinator.setWebView(webView)
    context.coordinator.setup()
    
    context.coordinator.setMimeType(mode.mimeType)
    context.coordinator.setContent(code)
    
    return webView
  }
  
  func updateNSView(_ codeMirrorView: WKWebView, context: Context) {
    context.coordinator.getMimeType({ result in
      
      switch result {
      case .success(let resp):
        guard let previousMimeType = resp as? String else { return }
        
        if previousMimeType != self.mode.mimeType {
            context.coordinator.setMimeType(self.mode.mimeType)
        }
        
        return
      case .failure(let error):
        print("Error \(error)")
        return
      }
    })
    
    context.coordinator.getContent({ result in
      
      switch result {
      case .success(let resp):
        guard let previousContent = resp as? String else { return }
        
        if previousContent != self.code {
          context.coordinator.setContent(self.code)
        }
        
        return
      case .failure(let error):
        print("Error \(error)")
        return
      }
    })
  }
  
  func makeCoordinator() -> CodeMirrorViewController {
    CodeMirrorViewController(self)
  }
  
  
}

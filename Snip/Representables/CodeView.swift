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
  
  @Environment(\.colorScheme) var colorScheme
  @EnvironmentObject var settings: Settings
  
  @Binding var code: String
  @Binding var mode: Mode
  
  var onLoadSuccess: (() -> ())? = nil
  var onLoadFail: ((Error) -> ())? = nil
  var onContentChange: ((String) -> ())? = nil
  
  func makeNSView(context: Context) -> WKWebView {
    
    let theme = (colorScheme == .dark) ? "material-palenight" : "base16-light"
    
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
    let htmlString = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "$theme", with: "\"\(theme)\"")
    webView.load(htmlString.data(using: .utf8)!, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: bundle.resourceURL!)
    
    context.coordinator.setThemeName(theme)
    context.coordinator.setTabInsertsSpaces(true)
    context.coordinator.setWebView(webView)
    context.coordinator.setup()
    
    context.coordinator.setMimeType(mode.mimeType)
    context.coordinator.setContent(code)
    
    return webView
  }
  
  func updateNSView(_ codeMirrorView: WKWebView, context: Context) {
    
    updateWhatsNecessary(elementGetter: context.coordinator.getMimeType(_:), elementSetter: context.coordinator.setMimeType(_:), currentElementState: self.mode.mimeType)
    
    updateWhatsNecessary(elementGetter: context.coordinator.getContent(_:), elementSetter: context.coordinator.setContent(_:), currentElementState: self.code)
    
    context.coordinator.setThemeName((colorScheme == .dark) ? "material-palenight" : "base16-light")
  }
  
  func makeCoordinator() -> CodeMirrorViewController {
    CodeMirrorViewController(self)
  }
  
  func updateWhatsNecessary(elementGetter: (JavascriptCallback?) -> Void,
                            elementSetter: @escaping (_ elementState: String) -> Void,
                            currentElementState: String) {
    elementGetter({ result in
      
      switch result {
      case .success(let resp):
        guard let previousElementState = resp as? String else { return }
        
        if previousElementState != currentElementState {
          elementSetter(currentElementState)
        }
        
        return
      case .failure(let error):
        print("Error \(error)")
        return
      }
    })
  }
}

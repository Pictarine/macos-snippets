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
  
  @Binding var code: String
  @Binding var mode: Mode
  var syntaxTheme: CodeViewTheme = .`default`
  var fontSize: Int
  var showInvisibleCharacters: Bool
  var lineWrapping: Bool
  var isReadOnly = false
  
  var onLoadSuccess: (() -> ())? = nil
  var onLoadFail: ((Error) -> ())? = nil
  var onContentChange: ((String) -> ())? = nil
  
  public init(theme: CodeViewTheme? = nil,
              code: Binding<String>,
              mode: Binding<Mode>,
              fontSize: Int = 12,
              showInvisibleCharacters: Bool = true,
              lineWrapping: Bool = true,
              isReadOnly: Bool = false) {
    self._code = code
    self._mode = mode
    self.fontSize = fontSize
    self.showInvisibleCharacters = showInvisibleCharacters
    self.lineWrapping = lineWrapping
    self.isReadOnly = isReadOnly
    
    if let theme = theme {
      self.syntaxTheme = theme
    }
  }
  
  func makeNSView(context: Context) -> WKWebView {
    
    let theme = syntaxTheme == .`default` ? ((colorScheme == .dark) ? CodeViewTheme.materialPalenight.rawValue : CodeViewTheme.base16Light.rawValue) : syntaxTheme.rawValue
    
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
    context.coordinator.setReadonly(isReadOnly)
    context.coordinator.setFontSize(fontSize)
    context.coordinator.setShowInvisibleCharacters(showInvisibleCharacters)
    context.coordinator.setLineWrapping(lineWrapping)
    
    return webView
  }
  
  func updateNSView(_ codeMirrorView: WKWebView, context: Context) {
    
    let theme = syntaxTheme == .`default` ? ((colorScheme == .dark) ? CodeViewTheme.materialPalenight.rawValue : CodeViewTheme.base16Light.rawValue) : syntaxTheme.rawValue
    
    updateWhatsNecessary(elementGetter: context.coordinator.getMimeType(_:), elementSetter: context.coordinator.setMimeType(_:), currentElementState: self.mode.mimeType)
    
    updateWhatsNecessary(elementGetter: context.coordinator.getContent(_:), elementSetter: context.coordinator.setContent(_:), currentElementState: self.code)
    
    context.coordinator.setReadonly(isReadOnly)
    context.coordinator.setThemeName(theme)
    context.coordinator.setFontSize(fontSize)
    context.coordinator.setShowInvisibleCharacters(showInvisibleCharacters)
    context.coordinator.setLineWrapping(lineWrapping)
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


// MARK: - Public API

extension CodeView {
  
  public func onLoadSuccess(_ action: @escaping (() -> ())) -> Self {
    var copy = self
    copy.onLoadSuccess = action
    return copy
  }
  
  public func onLoadFail(_ action: @escaping ((Error) -> ())) -> Self {
    var copy = self
    copy.onLoadFail = action
    return copy
  }
  
  public func onContentChange(_ action: @escaping ((String) -> ())) -> Self {
    var copy = self
    copy.onContentChange = action
    return copy
  }
}

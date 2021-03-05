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
import Combine


struct CodeView: NSViewRepresentable {
  
  @ObservedObject var viewModel: CodeViewerModel
  @EnvironmentObject var settings: Settings
  @Environment(\.colorScheme) var colorScheme
  
  func makeNSView(context: Context) -> WKWebView {
    
    let preferences = WKPreferences()
    
    let userController = WKUserContentController()
    userController.add(context.coordinator, name: CodeMirrorViewConstants.codeMirrorDidReady)
    userController.add(context.coordinator, name: CodeMirrorViewConstants.codeMirrorTextContentDidChange)
    userController.add(context.coordinator, name: CodeMirrorViewConstants.codeMirrorLog)
    
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
    let htmlString = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "$theme", with: "\"\(codeMirrorTheme)\"")
    webView.load(htmlString.data(using: .utf8)!, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: bundle.resourceURL!)
    
    context.coordinator.setTabInsertsSpaces(true)
    context.coordinator.setWebView(webView)
    context.coordinator.setup()

    context.coordinator.setMimeType(viewModel.mode.mimeType)
    context.coordinator.setContent(viewModel.code)
    
    updateSettings(context: context)
    
    return webView
  }
  
  func updateNSView(_ codeMirrorView: WKWebView, context: Context) {
    
    updateWhatsNecessary(elementGetter: context.coordinator.getMimeType(_:), elementSetter: context.coordinator.setMimeType(_:), currentElementState: viewModel.mode.mimeType)
    updateWhatsNecessary(elementGetter: context.coordinator.getContent(_:), elementSetter: context.coordinator.setContent(_:), currentElementState: viewModel.code)
    
    updateSettings(context: context)
  }
  
  func makeCoordinator() -> CodeMirrorViewController {
    return CodeMirrorViewController(self)
  }
  
  var codeMirrorTheme: String {
    if let theme = settings.codeViewTheme {
      if theme == .`default` {
        return (colorScheme == .dark) ? CodeViewTheme.materialPalenight.rawValue : CodeViewTheme.base16Light.rawValue
      }
      else {
        return theme.rawValue
      }
    }
    else {
      return (colorScheme == .dark) ? CodeViewTheme.materialPalenight.rawValue : CodeViewTheme.base16Light.rawValue
    }
  }
  
  func updateSettings(context: Context) {
    context.coordinator.setParent(self)
    context.coordinator.setReadonly(viewModel.isReadOnly)
    context.coordinator.setThemeName(codeMirrorTheme)
    context.coordinator.setFontSize(settings.codeViewTextSize)
    context.coordinator.setShowInvisibleCharacters(settings.codeViewShowInvisibleCharacters)
    context.coordinator.setLineWrapping(settings.codeViewLineWrapping)
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

final class CodeViewerModel: ObservableObject {
  
  @Published var code: String = ""
  @Published var mode: Mode = CodeMode.text.mode()
  
  var isReadOnly = false
  
  var onLoadSuccess: (() -> ())?
  var onLoadFail: ((Error) -> ())?
  var onContentChange: ((String) -> ())?
  
  var cancellable: AnyCancellable?
  
  init(snipItem: AnyPublisher<SnipItem?, Never>,
       isReadOnly: Bool = false,
       onLoadSuccess: (() -> ())? = nil,
       onLoadFail: ((Error) -> ())? = nil,
       onContentChange: ((String) -> ())? = nil) {
    
    self.isReadOnly = isReadOnly
    self.onLoadSuccess = onLoadSuccess
    self.onLoadFail = onLoadFail
    self.onContentChange = onContentChange
    
    cancellable = snipItem
      .sink { [weak self] (snipItem) in
        guard let this = self,
          let snipItem = snipItem
        else { return }
        
        this.code = snipItem.snippet
        this.mode = snipItem.mode
    }
  }
  
}

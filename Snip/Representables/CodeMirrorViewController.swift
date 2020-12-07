//
//  CodeMirrorWebViewController.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import WebKit


// MARK: JavascriptFunction

typealias JavascriptCallback = (Result<Any?, Error>) -> Void
private struct JavascriptFunction {
  
  let functionString: String
  let callback: JavascriptCallback?
  
  init(functionString: String, callback: JavascriptCallback? = nil) {
    self.functionString = functionString
    self.callback = callback
  }
}


// MARK: CodeMirrorViewController Coordinator

class CodeMirrorViewController: NSObject {
  var parent: CodeView
  weak var webView: WKWebView?
  
  fileprivate var pageLoaded = false
  fileprivate var pendingFunctions = [JavascriptFunction]()
  init(_ parent: CodeView) {
    self.parent = parent
  }
  
  // MARK: Properties
  
  func setTabInsertsSpaces(_ value: Bool) {
    callJavascript(javascriptString: "SetTabInsertSpaces(\(value));")
  }
  
  func setContent(_ value: String) {
    if let hexString = value.data(using: .utf8)?.hexEncodedString() {
      let script = """
      var content = "\(hexString)"; SetContent(content);
      """
      callJavascript(javascriptString: script)
    }
  }
  
  func getContent(_ block: JavascriptCallback?) {
    callJavascript(javascriptString: "GetContent();", callback: block)
  }
  
  func setMimeType(_ value: String) {
    callJavascript(javascriptString: "SetMimeType(\"\(value)\");")
  }
  
  func getMimeType(_ block: JavascriptCallback?) {
    callJavascript(javascriptString: "GetMimeType();", callback: block)
  }
  
  func setThemeName(_ value: String) {
    callJavascript(javascriptString: "SetTheme(\"\(value)\");")
  }
  
  func setLineWrapping(_ value: Bool) {
    callJavascript(javascriptString: "SetLineWrapping(\(value));")
  }
  
  func setFontSize(_ value: Int) {
    callJavascript(javascriptString: "SetFontSize(\(value));")
  }
  
  func setDefaultTheme() {
    setMimeType("application/json")
  }
  
  func setReadonly(_ value: Bool) {
    callJavascript(javascriptString: "SetReadOnly(\(value));")
  }
  
  func getTextSelection(_ block: JavascriptCallback?) {
    callJavascript(javascriptString: "GetTextSelection();", callback: block)
  }
  
  func setShowInvisibleCharacters(_ show: Bool) {
    callJavascript(javascriptString: "ToggleInvisible(\(show));")
  }
  
  fileprivate func configCodeMirror() {
    setTabInsertsSpaces(true)
  }
  
  private func addFunction(function:JavascriptFunction) {
    pendingFunctions.append(function)
  }
  
  private func callJavascriptFunction(function: JavascriptFunction) {
    webView?.evaluateJavaScript(function.functionString) { (response, error) in
      if let error = error {
        function.callback?(.failure(error))
      }
      else {
        function.callback?(.success(response))
      }
    }
  }
  
  private func callPendingFunctions() {
    for function in pendingFunctions {
      callJavascriptFunction(function: function)
    }
    pendingFunctions.removeAll()
  }
  
  private func callJavascript(javascriptString: String, callback: JavascriptCallback? = nil) {
    if pageLoaded {
      callJavascriptFunction(function: JavascriptFunction(functionString: javascriptString, callback: callback))
    }
    else {
      addFunction(function: JavascriptFunction(functionString: javascriptString, callback: callback))
    }
  }
}

extension CodeMirrorViewController: WKScriptMessageHandler {
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    print("didFinish")
    parent.onLoadSuccess?()
  }
  
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    print("didFail \(error.localizedDescription)")
    parent.onLoadFail?(error)
  }
  
  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    print("didFailProvisionalNavigation")
    parent.onLoadFail?(error)
  }
}

extension CodeMirrorViewController: WKNavigationDelegate {
  
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    
    // is Ready
    if message.name == CodeMirrorViewConstants.codeMirrorDidReady {
      pageLoaded = true
      callPendingFunctions()
      return
    }
    
    // Content change
    if message.name == CodeMirrorViewConstants.codeMirrorTextContentDidChange {
      let content = (message.body as? String) ?? ""
      
      if content != parent.code {
        
        print("Code changes ! \(content)")
        parent.onContentChange?(content)
        parent.code = content
      }
      return
    }
  }
  
}

extension CodeMirrorViewController {
  
  public func setWebView(_ webView: WKWebView) {
    self.webView = webView
  }
  
  public func setParent(_ parent: CodeView) {
    self.parent = parent
  }
  
  public func setup() {
    configCodeMirror()
  }
  
}

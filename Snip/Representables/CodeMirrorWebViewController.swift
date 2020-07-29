//
//  CodeMirrorWebViewController.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation



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


// MARK: CodeMirrorWebViewController Coordinator

class CodeMirrorViewController: NSObject {
  var parent: CodeView
  
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
      //
      // It's tricky to pass FULL JSON or HTML text with \n or "", ... into JS Bridge
      // Have to wrap with `data_here`
      // And use String.raw to prevent escape some special string -> String will show exactly how it's
      // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals
      //
      let first = "var content = String.raw`"
      let content = """
                    \(value)
                    """
      let end = "`; SetContent(content);"
      let script = first + content + end
      callJavascript(javascriptString: script)
  }

  func getContent(_ block: JavascriptCallback?) {
      callJavascript(javascriptString: "GetContent();", callback: block)
  }

  func setMimeType(_ value: String) {
      callJavascript(javascriptString: "SetMimeType(\"\(value)\");")
  }

  func setThemeName(_ value: Bool) {
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
  
  /*fileprivate func initWebView() {
    parent.allowsMagnification = false

    // Load CodeMirror bundle
    guard let bundlePath = Bundle.main.path(forResource: "CodeMirrorView", ofType: "bundle"),
        let bundle = Bundle(path: bundlePath),
        let indexPath = bundle.path(forResource: "index", ofType: "html") else {
            fatalError("CodeMirrorBundle is missing")
    }
    let data = try! Data(contentsOf: URL(fileURLWithPath: indexPath))
    parent.load(data, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: bundle.resourceURL!)
  }*/

  fileprivate func configCodeMirror() {
      setTabInsertsSpaces(true)
  }

  private func addFunction(function:JavascriptFunction) {
      pendingFunctions.append(function)
  }

  private func callJavascriptFunction(function: JavascriptFunction) {
      /*parent.evaluateJavaScript(function.functionString) { (response, error) in
          if let error = error {
              function.callback?(.failure(error))
          }
          else {
              function.callback?(.success(response))
          }
      }*/
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
        parent.onContentChange?(content)
      }
  }
  
}

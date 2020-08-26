//
//  MarkdownHTMLViewer.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/24/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import SwiftUI
import WebKit
import Down

struct MarkdownHTMLViewer: NSViewRepresentable {
  
  var code: String
  var mode: Mode
  
  fileprivate func setContent(_ webView: WKWebView) {
    
    var htmlSource = ""
    
    if mode == CodeMode.html.mode() {
      htmlSource = code
    }
    else if mode == CodeMode.markdown.mode() {
      
      let down = Down(markdownString: code)

      if let html = try? down.toHTML() {
          htmlSource = html
      }
    }
    
    webView.loadHTMLString(htmlSource, baseURL: nil)
  }
  
  func makeNSView(context: Context) -> WKWebView {
    let preferences = WKPreferences()
    preferences.javaScriptEnabled = true
    
    let configuration = WKWebViewConfiguration()
    configuration.preferences = preferences
    
    let webView = WKWebView(frame: .zero, configuration: configuration)
    webView.setValue(false, forKey: "drawsBackground")
    webView.allowsMagnification = false
    
    setContent(webView)
    
    return webView
  }
  
  func updateNSView(_ codeMirrorView: WKWebView, context: Context) {
    setContent(codeMirrorView)
  }
}

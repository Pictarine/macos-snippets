//
//  CodeMirrorWebViewDelegate.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation


protocol CodeMirrorViewDelegate: class {
  
  func codeMirrorViewDidLoadSuccess(_ sender: CodeView)
  func codeMirrorViewDidLoadError(_ sender: CodeView, error: Error)
  func codeMirrorViewDidChangeContent(_ sender: CodeView, content: String)
}

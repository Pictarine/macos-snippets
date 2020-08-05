//
//  SnippetFileManager.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/5/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation

class SnippetFileManager {
  
  static let shared = SnippetFileManager()
  
  fileprivate let saving_queue = DispatchQueue(label: "Snip.savingqueue", qos: .background)
  
  func saveSnippet(_ snippet: SnipItem) {
    
    saving_queue.async {
      StorageManager.store(snippet, to: .applicationSupport, as: "snippet.id")
    }
    
  }
}

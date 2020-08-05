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
      print("Saving \(snippet.id)")
      StorageManager.store(snippet, to: .applicationSupport, as: snippet.id)
    }
  }
  
  func getSnippet(from id: String) -> SnipItem {
    return StorageManager.retrieve("id", from: .applicationSupport, as: SnipItem.self)
  }
  
  func createFolder(folderName: String) {
    StorageManager.createDirectory(folderName: folderName, to: .applicationSupport)
  }
}

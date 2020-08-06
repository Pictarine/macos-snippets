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
  
  func saveSnippet(_ snippets: [SnipItem]) {
    
    saving_queue.async {
      print("Saving snippets")
      StorageManager.store(snippets, to: .applicationSupport, as: "snippets")
    }
  }
  
  func getSnippets() -> [SnipItem] {
    do {
      let snippets = try StorageManager.retrieve("snippets", from: .applicationSupport, as: [SnipItem].self)
      return snippets
    }
    catch {
      return Preview.snipItems
    }
    
  }
  
  func createFolder(folderName: String) {
    StorageManager.createDirectory(folderName: folderName, to: .applicationSupport)
  }
}

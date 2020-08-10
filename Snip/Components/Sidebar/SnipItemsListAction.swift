//
//  SnipItemsListAction.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/3/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation

enum TagJob {
  case add
  case remove
}

struct SnipItemsListAction {
  let handleModification: (inout [SnipItem]) -> Void
  
  static func addSnippet(id: String?) -> SnipItemsListAction {
    return .init { current in
      if let idParentFolder = id {
        let snipItem = current.flatternSnippets.first { (snipItem) -> Bool in
          return snipItem.id == idParentFolder
        }
        snipItem?.content.append(SnipItem.file(name: "New Snippet"))
      }
      else {
        current.append(SnipItem.file(name: "New Snippet"))
      }
    }
  }
  
  static func addFolder(id: String?) -> SnipItemsListAction {
    return .init { current in
      if let idParentFolder = id {
        let snipItem = current.flatternSnippets.first { (snipItem) -> Bool in
          return snipItem.id == idParentFolder
        }
        snipItem?.content.append(SnipItem.folder(name: "New Folder"))
      }
      else {
        current.append(SnipItem.folder(name: "New Folder"))
      }
    }
  }
  
  static func delete(id: String) -> SnipItemsListAction {
    return .init { current in
      current = SnipItemsListAction.removeNestedArray(for: id, current: current)
    }
  }
  
  static func toggleFavorite(id: String) -> SnipItemsListAction {
    return .init { current in
      let snipItem = current.flatternSnippets.first { (snipItem) -> Bool in
        return snipItem.id == id
      }
      snipItem?.isFavorite.toggle()
    }
  }
  
  static func rename(id: String, name: String) -> SnipItemsListAction {
    return .init { current in
      let snipItem = current.flatternSnippets.first { (snipItem) -> Bool in
        return snipItem.id == id
      }
      snipItem?.name = name
    }
  }
  
  static func updateMode(id: String, mode: Mode) -> SnipItemsListAction {
    return .init { current in
      let snipItem = current.flatternSnippets.first { (snipItem) -> Bool in
        return snipItem.id == id
      }
      snipItem?.mode = mode
    }
  }
  
  static func updateCode(id: String, code: String) -> SnipItemsListAction {
    return .init { current in
      let snipItem = current.flatternSnippets.first { (snipItem) -> Bool in
        return snipItem.id == id
      }
      snipItem?.snippet = code
    }
  }
  
  static func updateTags(id: String, job: TagJob, tag: String) -> SnipItemsListAction {
    return .init { current in
      let snipItem = current.flatternSnippets.first { (snipItem) -> Bool in
        return snipItem.id == id
      }
      if job == .add {
        snipItem?.tags.append(tag)
      }
      else {
        guard let tagIndex = snipItem?.tags.firstIndex(of: tag) else { return }
        snipItem?.tags.remove(at: tagIndex)
      }
    }
  }
  
  private static func removeNestedArray(for id: String,  current: [SnipItem]) -> [SnipItem] {
    var copy = current
    for (i, obj) in copy.enumerated() {
      
      if obj.id == id {
        copy.remove(at: i)
      }
      else {
        obj.content = SnipItemsListAction.removeNestedArray(for: id, current: obj.content)
      }
      
    }
    return copy
    
  }
}

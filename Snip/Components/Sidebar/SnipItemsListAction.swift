//
//  SnipItemsListAction.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/3/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import Combine

var stores: Set<AnyCancellable> = []

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
  
  static func createGist(id: String) -> SnipItemsListAction {
    return .init { current in
      let snipItem = current.flatternSnippets.first { (snipItem) -> Bool in
        return snipItem.id == id
      }
      
      guard let snip = snipItem else { return }
      
      snip.syncState = .syncing
      
      SyncManager.shared.createGist(title: snip.name, code: snip.snippet)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { (completion) in
          if case let .failure(error) = completion {
            print(error)
          }
        }, receiveValue: { (gist) in
          snip.gistId = gist.id
          snip.gistURL = gist.url
          snip.syncState = .synced
        })
        .store(in: &stores)
    }
  }
  
  static func toggleFavorite(id: String) -> SnipItemsListAction {
    return .init { current in
      let snipItem = current.flatternSnippets.first { (snipItem) -> Bool in
        return snipItem.id == id
      }
      snipItem?.isFavorite.toggle()
      snipItem?.lastUpdateDate = Date()
    }
  }
  
  static func rename(id: String, name: String) -> SnipItemsListAction {
    return .init { current in
      let snipItem = current.flatternSnippets.first { (snipItem) -> Bool in
        return snipItem.id == id
      }
      snipItem?.name = name
      snipItem?.lastUpdateDate = Date()
    }
  }
  
  static func updateMode(id: String, mode: Mode) -> SnipItemsListAction {
    return .init { current in
      let snipItem = current.flatternSnippets.first { (snipItem) -> Bool in
        return snipItem.id == id
      }
      snipItem?.mode = mode
      snipItem?.lastUpdateDate = Date()
    }
  }
  
  static func updateCode(id: String, code: String) -> SnipItemsListAction {
    return .init { current in
      let snipItem = current.flatternSnippets.first { (snipItem) -> Bool in
        return snipItem.id == id
      }
      
      guard let snip = snipItem else { return }
      
      if snip.snippet != code {
        snip.snippet = code
        snip.lastUpdateDate = Date()
      }
      
      snip.syncState = .syncing
      
      SyncManager.shared.createGist(title: snip.name, code: snip.snippet)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { (completion) in
          if case let .failure(error) = completion {
            print(error)
          }
        }, receiveValue: { (gist) in
          snip.gistId = gist.id
          snip.gistURL = gist.url
          snip.syncState = .synced
        })
        .store(in: &stores)
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
      snipItem?.lastUpdateDate = Date()
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

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
  
  
  static func addSnippet(id: String? = nil) -> SnipItemsListAction {
    return .init { current in
      
      let file = SnipItem.file(name: NSLocalizedString("New_Snippet", comment: "").capitalized)
      
      if let idParentFolder = id {
        let snipItem = current.flatternSnippets.first { (snipItem) -> Bool in
          return snipItem.id == idParentFolder
        }
        
        snipItem?.content.append(file)
      }
      else {
        current.append(file)
      }
    }
  }
  
  static func addExternalSnippet(externalSnipItem: SnipItem) -> SnipItemsListAction {

    return .init { current in
      let snipItem = current.flatternSnippets.first { (snipItem) -> Bool in
        return snipItem.kind == .folder && snipItem.name == "StackOverflow"
      }
      
      if let snipItem = snipItem {
        
        snipItem.content.append(externalSnipItem)
      }
      else {
        current.append(SnipItem.folder(name: "StackOverflow"))
        
        let snipItem = current.flatternSnippets.first { (snipItem) -> Bool in
          return snipItem.kind == .folder && snipItem.name == "StackOverflow"
        }
        
        snipItem?.content.append(externalSnipItem)
      }
      
    }
  }
  
  static func addFolder(id: String? = nil) -> SnipItemsListAction {
    return .init { current in
      
      let folder = SnipItem.folder(name: NSLocalizedString("New_Folder", comment: "").capitalized)
      
      if let idParentFolder = id {
        let snipItem = current.flatternSnippets.first { (snipItem) -> Bool in
          return snipItem.id == idParentFolder
        }
        
        snipItem?.content.append(folder)
      }
      else {
        current.append(folder)
      }
    }
  }
  
  static func delete(id: String) -> SnipItemsListAction {
    return .init { current in
      current = SnipItemsListAction.removeNestedArray(for: id, current: current)
    }
  }
  
  static func folderFromSelection(id: String) -> SnipItemsListAction {
    return .init { current in
      
      // Get Item
      let snipItem = current.flatternSnippets.first { (snipItem) -> Bool in
        return snipItem.id == id
      }
      
      guard let snip = snipItem else { return }
      
      // Find closest parent
      let closestParent = current.first { (snipItem) -> Bool in
        return snipItem.content.first { (subSnipItem) -> Bool in
          return subSnipItem.id == id
        } != nil
      }
      
      if let closestParent = closestParent {
        
        // Remove item from parent
        closestParent.content.removeAll { (snipItem) -> Bool in
          return snipItem.id == id
        }
        
        // Create new folder
        let folder = SnipItem.folder(name: NSLocalizedString("New_Folder", comment: "").capitalized)
        folder.content.append(snip)
        
        // Add new folder
        closestParent.content.append(folder)
      }
      else {
        // Root folder
        
        // Remove item from parent
        current.removeAll { (snipItem) -> Bool in
          return snipItem.id == id
        }
        
        // Create new folder
        let folder = SnipItem.folder(name: NSLocalizedString("New_Folder", comment: "").capitalized)
        folder.content.append(snip)
        
        // Add new folder
        current.append(folder)
      }
    }
  }
  
  static func createGist(id: String) -> SnipItemsListAction {
    return .init { current in
      let snipItem = current.flatternSnippets.first { (snipItem) -> Bool in
        return snipItem.id == id
      }
      
      guard let snip = snipItem else { return }
      
      snip.syncState = .syncing
      
      DispatchQueue.global().async {
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
        
        if let gistId = snip.gistId,
        gistId.count > 0 {
            
          snip.syncState = .syncing
          
          DispatchQueue.global().async {
            SyncManager.shared.updateGist(id: gistId, title: snip.name, code: snip.snippet)
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
      }
      
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

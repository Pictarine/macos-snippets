//
//  SnippetFileManager.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/5/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import Combine


class SnippetManager {
  static let shared = SnippetManager()
  
  public var snipets: AnyPublisher<[SnipItem], Never>
  fileprivate let snippetActionSubject: PassthroughSubject<SnipItemsListAction, Never> = .init()
  fileprivate let saving_queue = DispatchQueue(label: "Snip.savingqueue", qos: .background)
  
  init() {

    let snippets = Self.getSnippets()
    let initial: AnyPublisher<[SnipItem], Never> = Just(snippets).eraseToAnyPublisher()
    self.snipets = snippetActionSubject
      .scan(snippets, { (currentSnippets, action) -> [SnipItem] in
        var copy = currentSnippets
        action.handleModification(&copy)
        return copy
      })
      .handleEvents(receiveOutput: SnippetManager.saveSnippets(on: saving_queue))
      .prepend(initial)
      .eraseToAnyPublisher()
  }
}


// MARK: - Item Update API

extension SnippetManager {
  public func trigger(action: SnipItemsListAction) {
    snippetActionSubject.send(action)
  }
  
}


// MARK: - Disk File Manager

extension SnippetManager {
  
  static func saveSnippets(on queue: DispatchQueue) -> ([SnipItem]) -> Void {
    return { snippets in
      queue.async {
        print("Saving snippets")
        StorageManager.store(snippets, to: .applicationSupport, as: "snippets")
      }
    }
    
  }
  
  static func getSnippets() -> [SnipItem] {
    
    do {
      let snippets = try StorageManager.retrieve("snippets", from: .applicationSupport, as: [SnipItem].self)
      return snippets
    }
    catch {
      return [] //Preview.snipItems
    }
  }
  
  func createFolder(folderName: String) {
    StorageManager.createDirectory(folderName: folderName, to: .applicationSupport)
  }
  
}

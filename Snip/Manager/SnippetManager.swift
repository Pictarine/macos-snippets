//
//  SnippetFileManager.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/5/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import Combine
import SwiftUI


class SnippetManager: ObservableObject {
  
  static let shared = SnippetManager()
  
  @Published var hasExternalSnippetQueued = false
  @Published var tempSnipItem : SnipItem? = nil
  
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
  
  public func addSnippet(code: String, title: String, tags: [String], from: String) {
    
    tempSnipItem = SnipItem.file(name: title)
    tempSnipItem?.snippet = code
    tempSnipItem?.tags = tags
    
    withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 40.0, damping: 11, initialVelocity: 0)) { () -> () in
      hasExternalSnippetQueued = true
    }
    
    /*var index = snippets.firstIndex(where: { (snip) -> Bool in
      snip.kind == .folder && snip.name == "StackOverflow"
    }) ?? -1
    
    if index >= 0 {
      print("Contains")
    }
    else {
      print("Does not contains")
      SnippetManager.shared.trigger(action: .addFolder(name: "StackOverflow"))
      
      index = snippets.firstIndex(where: { (snip) -> Bool in
        snip.kind == .folder && snip.name == "StackOverflow"
      }) ?? -1
    }
    
    trigger(action: .addSnippet(id: snippets[index].id, name: title, code: code, tags: tags))*/
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

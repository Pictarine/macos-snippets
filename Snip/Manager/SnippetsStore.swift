//
//  Session.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/6/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class SnippetStore: ObservableObject {
  
  @Published var snipItems: [SnipItem]
  
  private var stores = Set<AnyCancellable>()
  
  init(snippets: [SnipItem]) {
    snipItems = snippets
    
    for snipItem in snipItems {
      snipItem.objectWillChange.sink { [weak self] (_) in
        
        guard let this = self else { return }
        
        print("Model whill change for \(snipItem.name)")
        
        SnippetFileManager.shared.saveSnippet(this.snipItems)
        
        this.objectWillChange.send()
      }
      .store(in: &stores)
    }
  }
}

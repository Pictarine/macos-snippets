//
//  SnipItem.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation


public struct SnipItem: Codable, Identifiable {
  
  public var id: UUID
  
  enum Kind: Int, Codable {
    case folder
    case file
  }
  
  let name: String
  let kind: Kind
  var content: [SnipItem]?
  let tags: [String]
  let isFavorite: Bool
  let creationDate: Date
  let lastUpdateDate: Date
  
  static func folder(name: String) -> SnipItem {
    .init(
      id: UUID(),
      name: name,
      kind: .folder,
      content: [],
      tags: [],
      isFavorite: false,
      creationDate: Date(),
      lastUpdateDate: Date()
    )
  }
  
  static func file(name: String) -> SnipItem {
    .init(
      id: UUID(),
      name: name,
      kind: .file,
      content: [],
      tags: [],
      isFavorite: false,
      creationDate: Date(),
      lastUpdateDate: Date()
    )
  }
}


extension SnipItem {
  
  static func preview() -> [SnipItem] {
    return [
      SnipItem(id: UUID(),
               name: "Hello",
               kind: .folder,
               content: [],
               tags: [],
               isFavorite: false,
               creationDate: Date(),
               lastUpdateDate: Date()),
      SnipItem(id: UUID(),
               name: "IM",
               kind: .folder,
               content: [
                SnipItem(id: UUID(),
                         name: "Folder #1",
                         kind: .folder,
                         content: [
                          SnipItem(id: UUID(),
                                   name: "Folder #2",
                                   kind: .folder,
                                   content: [],
                                   tags: [],
                                   isFavorite: false,
                                   creationDate: Date(),
                                   lastUpdateDate: Date()),
                          SnipItem(id: UUID(),
                                   name: "File #1",
                                   kind: .file,
                                   content: [],
                                   tags: [],
                                   isFavorite: true,
                                   creationDate: Date(),
                                   lastUpdateDate: Date())
                  ],
                         tags: [],
                         isFavorite: false,
                         creationDate: Date(),
                         lastUpdateDate: Date())
        ],
               tags: [],
               isFavorite: false,
               creationDate: Date(),
               lastUpdateDate: Date()),
      SnipItem(id: UUID(),
               name: "BATMAN",
               kind: .file,
               content: [],
               tags: [],
               isFavorite: true,
               creationDate: Date(),
               lastUpdateDate: Date())
    ]
  }
  
}

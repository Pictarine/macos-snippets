//
//  SnipItem.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import Combine


public class SnipItem: Identifiable, Equatable {
  
  public var id: UUID
  
  enum Kind: Int, Codable {
    case folder
    case file
  }
  
  var snippet: String
  var mode: Mode
  var tags: [String]
  var name: String
  var isFavorite: Bool
  
  var kind: Kind
  var content: [SnipItem]?
  var creationDate: Date
  var lastUpdateDate: Date
  
  init(
    id: UUID,
    name: String,
    kind: Kind,
    content: [SnipItem],
    snippet: String,
    mode: Mode,
    tags: [String],
    isFavorite: Bool,
    creationDate: Date,
    lastUpdateDate: Date
  ) {
    self.id = id
    self.name = name
    self.kind = kind
    self.content = content
    self.snippet = snippet
    self.mode = mode
    self.tags = tags
    self.isFavorite = isFavorite
    self.creationDate = creationDate
    self.lastUpdateDate = lastUpdateDate
  }
  
  static func folder(name: String) -> SnipItem {
    .init(
      id: UUID(),
      name: name,
      kind: .folder,
      content: [],
      snippet: "",
      mode: CodeMode.text.mode(),
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
      snippet: "",
      mode: CodeMode.text.mode(),
      tags: [],
      isFavorite: false,
      creationDate: Date(),
      lastUpdateDate: Date()
    )
  }
  
  public static func == (lhs: SnipItem, rhs: SnipItem) -> Bool {
    return lhs.id == rhs.id
  }
}


extension SnipItem {
  
  static let previewSnipItem = SnipItem(id: UUID(),
                                        name: "File #1",
                                        kind: .file,
                                        content: [],
                                        snippet: try! String(contentsOf: Bundle.main.url(forResource: "data", withExtension: "json")!),
                                        mode: CodeMode.json.mode(),
                                        tags: ["json", "matrix", "pinguin"],
                                        isFavorite: true,
                                        creationDate: Date(),
                                        lastUpdateDate: Date())
  
  static func preview() -> [SnipItem] {
    return [
      SnipItem(id: UUID(),
               name: "Hello",
               kind: .folder,
               content: [],
               snippet: "",
               mode: CodeMode.text.mode(),
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
                                   snippet: "",
                                   mode: CodeMode.text.mode(),
                                   tags: [],
                                   isFavorite: false,
                                   creationDate: Date(),
                                   lastUpdateDate: Date()),
                          SnipItem(id: UUID(),
                                   name: "File #1",
                                   kind: .file,
                                   content: [],
                                   snippet: try! String(contentsOf: Bundle.main.url(forResource: "data", withExtension: "json")!),
                                   mode: CodeMode.json.mode(),
                                   tags: ["json", "matrix", "pinguin"],
                                   isFavorite: true,
                                   creationDate: Date(),
                                   lastUpdateDate: Date())
                  ],
                         snippet: "",
                         mode: CodeMode.text.mode(),
                         tags: [],
                         isFavorite: false,
                         creationDate: Date(),
                         lastUpdateDate: Date())
        ],
               snippet: "",
               mode: CodeMode.text.mode(),
               tags: [],
               isFavorite: false,
               creationDate: Date(),
               lastUpdateDate: Date()),
      SnipItem(id: UUID(),
               name: "BATMAN",
               kind: .file,
               content: [],
               snippet: "Create your first Snip",
               mode: CodeMode.text.mode(),
               tags:["robin", "alfred", "batwat"],
               isFavorite: true,
               creationDate: Date(),
               lastUpdateDate: Date())
    ]
  }
  
}

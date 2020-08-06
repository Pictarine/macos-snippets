//
//  Preview.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/6/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation

struct Preview {
  
  static let snipItem = SnipItem(id: UUID(),
                                        name: "File #1",
                                        kind: .file,
                                        content: [],
                                        snippet: try! String(contentsOf: Bundle.main.url(forResource: "data", withExtension: "json")!),
                                        mode: CodeMode.json.mode(),
                                        tags: ["json", "matrix", "pinguin"],
                                        isFavorite: true,
                                        creationDate: Date(),
                                        lastUpdateDate: Date())
  
  static let snipItems = [
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

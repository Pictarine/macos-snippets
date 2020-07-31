//
//  SnipItem.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation


struct SnipItem: Codable, Identifiable {
  
  var id : String { name }
  
  enum Kind: Int, Codable {
    case folder
    case file
  }
  
  let name: String
  let kind: Kind
  var content: [SnipItem]?
  let tags: [String]
  let creationDate: Date
  let lastUpdateDate: Date
  
  static func folder(name: String) -> SnipItem {
    .init(
      name: name,
      kind: .folder,
      content: [],
      tags: [],
      creationDate: Date(),
      lastUpdateDate: Date()
    )
  }
  
  static func file(name: String) -> SnipItem {
    .init(
      name: name,
      kind: .file,
      content: [],
      tags: [],
      creationDate: Date(),
      lastUpdateDate: Date()
    )
  }
}

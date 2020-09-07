//
//  SnipItem.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import Combine


struct TempSnipItemToAdd {
  let name: String
  let url : String
  let tags: [String]
  let snippet: String
  let mode: Mode
}


class SnipItem: Identifiable, Equatable, Codable, ObservableObject, Hashable {
  
  enum CodingKeys: CodingKey {
      case snippet, mode, tags, name, isFavorite, content, id, kind, creationDate, lastUpdateDate, syncState, gistId, gistURL
  }
  
  enum Kind: Int, Codable {
    case folder
    case file
  }
  
  enum SyncState: Int, Codable {
    case local
    case syncing
    case synced
  }
  
  @Published var snippet: String
  @Published var mode: Mode
  @Published var tags: [String]
  @Published var name: String
  @Published var isFavorite: Bool
  @Published var content: [SnipItem]
  @Published var syncState: SyncState?
  @Published var gistId: String?
  @Published var gistURL: String?
  
  var id: String
  var kind: Kind
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
    lastUpdateDate: Date,
    syncState: SyncState?,
    gistId: String?,
    gistURL: String?
  ) {
    self.id = id.uuidString
    self.name = name
    self.kind = kind
    self.content = content
    self.snippet = snippet
    self.mode = mode
    self.tags = tags
    self.isFavorite = isFavorite
    self.creationDate = creationDate
    self.lastUpdateDate = lastUpdateDate
    self.syncState = syncState
    self.gistId = gistId
    self.gistURL = gistURL
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
      lastUpdateDate: Date(),
      syncState: .local,
      gistId: nil,
      gistURL: nil
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
      lastUpdateDate: Date(),
      syncState: .local,
      gistId: nil,
      gistURL: nil
    )
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    snippet = try container.decode(String.self, forKey: .snippet)
    mode = try container.decode(Mode.self, forKey: .mode)
    tags = try container.decode([String].self, forKey: .tags)
    name = try container.decode(String.self, forKey: .name)
    isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    content = try container.decode([SnipItem].self, forKey: .content)
    id = try container.decode(String.self, forKey: .id)
    kind = try container.decode(Kind.self, forKey: .kind)
    creationDate = try container.decode(Date.self, forKey: .creationDate)
    lastUpdateDate = try container.decode(Date.self, forKey: .lastUpdateDate)
    syncState = try? container.decode(SyncState.self, forKey: .syncState)
    
    if syncState == .syncing {
      syncState = .synced
    }
    
    gistId = try? container.decode(String.self, forKey: .gistId)
    gistURL = try? container.decode(String.self, forKey: .gistURL)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(snippet, forKey: .snippet)
    try container.encode(mode, forKey: .mode)
    try container.encode(tags, forKey: .tags)
    try container.encode(name, forKey: .name)
    try container.encode(isFavorite, forKey: .isFavorite)
    try container.encode(content, forKey: .content)
    try container.encode(id, forKey: .id)
    try container.encode(kind, forKey: .kind)
    try container.encode(creationDate, forKey: .creationDate)
    try container.encode(lastUpdateDate, forKey: .lastUpdateDate)
    try container.encode(syncState, forKey: .syncState)
    try container.encode(gistId, forKey: .gistId)
    try container.encode(gistURL, forKey: .gistURL)
  }
  
  static func == (lhs: SnipItem, rhs: SnipItem) -> Bool {
    return lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
      hasher.combine(id)
  }
}

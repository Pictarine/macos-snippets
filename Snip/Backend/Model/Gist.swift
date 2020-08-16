//
//  Gist.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/17/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation


struct GistFile: Codable {
  let filename: String
  let language: String
  let size: Int
  let content: String
}


struct Gist: Codable {
  
  enum CodingKeys: String, CodingKey {
    case url, id, files, isPublic = "public"
  }
  
  let url: String
  let id: String
  let files: [GistFile]
  let isPublic: Bool
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    url = try container.decode(String.self, forKey: .url)
    id = try container.decode(String.self, forKey: .id)
    files = try container.decode([GistFile].self, forKey: .files)
    isPublic = try container.decode(Bool.self, forKey: .isPublic)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(url, forKey: .url)
    try container.encode(id, forKey: .id)
    try container.encode(files, forKey: .files)
    try container.encode(isPublic, forKey: .isPublic)
  }
}

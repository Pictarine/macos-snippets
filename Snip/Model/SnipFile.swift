//
//  SnipFile.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation


public struct SnipFile: Codable {
  
  let name: String
  let content: String
  let mode: Mode
  let tags: [String]
  let creationDate: Date
  let lastUpdateDate: Date
  
}

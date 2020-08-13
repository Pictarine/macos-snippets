//
//  User.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/13/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation

public struct User: Codable {
  
  let login: String
  let name: String
  let company: String?
  let avatar_url: String?
  
}

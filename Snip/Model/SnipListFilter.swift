//
//  SnipListFilter.swift
//  Snip
//
//  Created by Junior on 04/03/2021.
//  Copyright © 2021 pictarine. All rights reserved.
//

import Foundation

enum ModelFilter: Equatable {
  case all
  case favorites
  case gist
  case tag(tagTitle: String)
  
  enum Case { case all, favorites, tag, gist }
  
  var `case`: Case {
    switch self {
      case .all: return .all
      case .favorites: return .favorites
      case .tag: return .tag
      case .gist: return .gist
    }
  }
}

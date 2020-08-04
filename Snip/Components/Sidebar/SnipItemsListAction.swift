//
//  SnipItemsListAction.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/3/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation

enum SnipItemsListAction {
  case addSnippet(id: UUID)
  case addFolder(id: UUID)
  case rename(id: UUID)
  case delete(id: UUID)
}

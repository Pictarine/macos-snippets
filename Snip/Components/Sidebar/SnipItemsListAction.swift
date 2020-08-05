//
//  SnipItemsListAction.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/3/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation

enum SnipItemsListAction {
  case addSnippet(id: String)
  case addFolder(id: String)
  case rename(id: String)
  case delete(id: String)
}

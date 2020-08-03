//
//  SnipItemsListAction.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/3/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation

enum SnipItemsListAction {
  case addSnippet(elementName: String)
  case addFolder(elementName: String)
  case rename(elementName: String)
  case delete(elementName: String)
}

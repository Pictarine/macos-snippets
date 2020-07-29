//
//  SnipFolder.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation


public struct SnipFolder<T: Codable>: Codable {
  
  let name: String
  let content: T
  
}

//
//  String.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/30/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation


extension String {
  
  func wordCount() -> Int {
    return words.count
  }
  
  func characterCount() -> Int {
    return count
  }
  
  func lineCount() -> Int {
    var numberOfLines = 0
    self.enumerateLines { _,_  in
        numberOfLines += 1
    }
    
    return numberOfLines
  }
  
}

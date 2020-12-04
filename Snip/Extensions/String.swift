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
  
  func size() -> String {
    let data = self.data(using: .utf8)
    let bcf = ByteCountFormatter()
    bcf.allowedUnits = [.useAll]
    bcf.countStyle = .file
    let size = bcf.string(fromByteCount: Int64(data!.count))
    return size
  }
  
  func fromBase64() -> String? {
      guard let data = Data(base64Encoded: self) else {
          return nil
      }

      return String(data: data, encoding: .utf8)
  }

  func toBase64() -> String {
      return Data(self.utf8).base64EncodedString()
  }
}

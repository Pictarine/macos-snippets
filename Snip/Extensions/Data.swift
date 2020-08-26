//
//  Data.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/26/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation

extension Data {
  func hexEncodedString() -> String {
    return map { String(format: "%02hhx", $0) }.joined()
  }
}

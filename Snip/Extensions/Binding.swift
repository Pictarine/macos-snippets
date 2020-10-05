//
//  Binding.swift
//  Snip
//
//  Created by Anthony Fernandez on 10/5/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import SwiftUI

extension Binding {
  func didSet(execute: @escaping (Value) -> Void) -> Binding {
    return Binding(
      get: {
        return self.wrappedValue
      },
      set: {
        self.wrappedValue = $0
        execute($0)
      }
    )
  }
}

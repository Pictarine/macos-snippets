//
//  List.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/2/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import Introspect
import SwiftUI

extension List {
  /// List on macOS uses an opaque background with no option for
  /// removing/changing it. listRowBackground() doesn't work either.
  /// This workaround works because List is backed by NSTableView.
  func removeBackground() -> some View {
    return introspectTableView { tableView in
      tableView.backgroundColor = .clear
      tableView.enclosingScrollView!.drawsBackground = false
    }
  }
}

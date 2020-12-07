//
//  AppState.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/11/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
  
  @Published var selectedSnippetId: String? = ""
  @Published var selectedSnippetFilter: ModelFilter = .all
  
  @Published var shouldShowChangelogModel: Bool {
    didSet {
      UserDefaults.standard.set(Bundle.main.buildVersionNumber, forKey: "previous_launched_version")
    }
  }
  
  init() {
    self.shouldShowChangelogModel = (UserDefaults.standard.object(forKey: "previous_launched_version") as? String ?? "") != Bundle.main.buildVersionNumber
  }
}

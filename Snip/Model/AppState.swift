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
  
  private let KEY_PREVIOUS_VERSION: String = "previous_launched_version"
  
  @Published var selectedSnippetId: String? = ""
  @Published var selectedSnippetFilter: ModelFilter = .all
  
  @Published var shouldShowChangelogModel: Bool {
    didSet {
      UserDefaults.standard.set(Bundle.main.buildVersionNumber, forKey: KEY_PREVIOUS_VERSION)
    }
  }
  
  init() {
    self.shouldShowChangelogModel = (UserDefaults.standard.object(forKey: KEY_PREVIOUS_VERSION) as? String ?? "") != Bundle.main.buildVersionNumber
  }
}

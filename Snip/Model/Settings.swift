//
//  Settings.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import SwiftUI

class Settings: ObservableObject {
  
  @Published var isSettingsOpened : Bool = false
  @Published var codeMirrorTheme : CodeViewTheme? = nil {
    didSet {
      guard let activeTheme = codeMirrorTheme else { return }
      UserDefaults.standard.set(activeTheme.rawValue, forKey: "codeview_active_theme")
    }
  }
  
  init() {
    if let activeTheme = UserDefaults.standard.object(forKey: "codeview_active_theme") as? String {
      codeMirrorTheme = CodeViewTheme(rawValue: activeTheme)
    }
  }
}

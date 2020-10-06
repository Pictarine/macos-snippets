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
  
  private enum keys: String {
    case invisibleCharacters = "codeview_show_invisible_characters"
    case theme = "codeview_active_theme"
    case lineWrapping = "codeview_line_wrapping"
    case textSize = "codeview_text_size"
    case appTheme = "snip_app_theme"
  }
  
  @Published var isSettingsOpened : Bool = false
  
  @Published var snipAppTheme : SnipAppTheme = .auto {
    didSet {
      UserDefaults.standard.set(snipAppTheme.rawValue, forKey: keys.appTheme.rawValue)
    }
  }
  
  @Published var codeViewTextSize : Int = 12 {
    didSet {
      UserDefaults.standard.set(codeViewTextSize, forKey: keys.textSize.rawValue)
    }
  }
  
  @Published var codeViewShowInvisibleCharacters: Bool = false  {
    didSet {
      UserDefaults.standard.set(codeViewShowInvisibleCharacters, forKey: keys.invisibleCharacters.rawValue)
    }
  }
  
  @Published var codeViewLineWrapping: Bool = false {
    didSet {
      UserDefaults.standard.set(codeViewLineWrapping, forKey: keys.lineWrapping.rawValue)
    }
  }
  
  @Published var codeViewTheme : CodeViewTheme? = nil {
    didSet {
      guard let activeTheme = codeViewTheme else { return }
      UserDefaults.standard.set(activeTheme.rawValue, forKey: keys.theme.rawValue)
    }
  }
  
  init() {
    if let activeTheme = UserDefaults.standard.object(forKey: keys.theme.rawValue) as? String {
      codeViewTheme = CodeViewTheme(rawValue: activeTheme)
    }
    
    if let appTheme = UserDefaults.standard.object(forKey: keys.appTheme.rawValue) as? String {
      snipAppTheme = SnipAppTheme(rawValue: appTheme) ?? .auto
    }
    else {
      snipAppTheme = .auto
    }
    
    codeViewShowInvisibleCharacters = UserDefaults.standard.bool(forKey: keys.invisibleCharacters.rawValue)
    codeViewLineWrapping = UserDefaults.standard.bool(forKey: keys.lineWrapping.rawValue)
    codeViewTextSize = UserDefaults.standard.integer(forKey: keys.textSize.rawValue)
    if codeViewTextSize == 0 {
      codeViewTextSize = 12
    }
  }
}

//
//  EnvironmentValues.swift
//  Snip
//
//  Created by Anthony Fernandez on 10/6/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import SwiftUI

private struct SnipThemePrimaryColor: EnvironmentKey {
  static let defaultValue: Color = .primary
}

private struct SnipThemeSecondaryColor: EnvironmentKey {
  static let defaultValue: Color = .secondary
}

private struct SnipThemeTextColor: EnvironmentKey {
  static let defaultValue: Color = .text
}

private struct SnipThemeShadowColor: EnvironmentKey {
  static let defaultValue: Color = .shadow
}

extension EnvironmentValues {
  var themePrimaryColor: Color {
    get { self[SnipThemePrimaryColor.self] }
    set { self[SnipThemePrimaryColor.self] = newValue }
  }
  
  var themeSecondaryColor: Color {
    get { self[SnipThemeSecondaryColor.self] }
    set { self[SnipThemeSecondaryColor.self] = newValue }
  }
  
  var themeTextColor: Color {
    get { self[SnipThemeTextColor.self] }
    set { self[SnipThemeTextColor.self] = newValue }
  }
  
  var themeShadowColor: Color {
    get { self[SnipThemeShadowColor.self] }
    set { self[SnipThemeShadowColor.self] = newValue }
  }
}

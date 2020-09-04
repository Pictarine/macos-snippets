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
  @Published var codeMirrorTheme : String = "material-palenight"
  
  /*withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 40.0, damping: 11, initialVelocity: 0)) { () -> () in
    isPresentingSnippetAdding = true
  }*/
}

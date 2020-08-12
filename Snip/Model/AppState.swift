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
}

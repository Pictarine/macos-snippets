//
//  SidebarTagView.swift
//  Snip
//
//  Created by Junior on 03/03/2021.
//  Copyright © 2021 pictarine. All rights reserved.
//

import SwiftUI

struct SidebarTagView: View {
  
  @ObservedObject var viewModel: SidebarTagViewModel
  
  var body: some View {
    Text(viewModel.tag.capitalized)
  }
}

final class SidebarTagViewModel: ObservableObject {
  
  var tag: String = ""
  
  init(tag: String) {
    self.tag = tag
  }
}

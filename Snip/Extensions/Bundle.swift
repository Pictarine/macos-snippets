//
//  Bundle.swift
//  Snip
//
//  Created by Anthony Fernandez on 9/10/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation


extension Bundle {
  
  var releaseVersionNumber: String {
    return (infoDictionary!["CFBundleShortVersionString"] as! String)
  }
  var buildVersionNumber: String {
      return (infoDictionary!["CFBundleVersion"] as! String)
  }
  
}

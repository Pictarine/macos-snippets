//
//  DeepLinkManager.swift
//  Snip
//
//  Created by Anthony Fernandez on 9/7/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation


struct DeepLinkManager {
  
  static let callbackURL = "snip://callback"
  static let addURL = "snip://add"
  
  static func handleDeepLink(urls: [URL]) {
    
    guard let url = urls.first,
      let params = url.queryParameters else { return }
    
    if url.absoluteString.starts(with: callbackURL),
      let code = params["code"],
      let state = params["state"] {
      
      SyncManager.shared.requestAccessToken(code: code,
                                            state: state)
    }
      
    else if url.absoluteString.starts(with: addURL),
      let code = params["code"],
      let title = params["title"],
      let tags = params["tags"],
      let source = params["source"] {
      
      let tagsArray = tags.fromBase64()!.split(separator: ";").map({ (substring) in
        return String(substring)
      })
      
      SnippetManager.shared.addSnippet(code: code.fromBase64()!,
                                       title: title.fromBase64()!,
                                       tags: tagsArray,
                                       source: source.fromBase64()!)
    }
      
    else {
      print(url.absoluteString)
    }
    
  }
  
}

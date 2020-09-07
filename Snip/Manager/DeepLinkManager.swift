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
      let from = params["from"],
      let title = params["title"],
      let tags = params["tags"] {
      
      let tagsArray = tags.fromBase64()!.split(separator: ";").map({ (substring) in
        return String(substring)
      })
      
      SnippetManager.shared.addSnippet(code: code.fromBase64()!,
                                       title: title.fromBase64()!,
                                       tags: tagsArray,
                                       from: from)
    }
      
    else {
      print(url.absoluteString)
    }
    
  }
  
}

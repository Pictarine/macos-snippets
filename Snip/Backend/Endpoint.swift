//
//  Endpoint.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/13/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation


public enum Endpoint {
  
  case token
  case user
  case gists
  case getGist(id: String)
  case updateGist(id: String)
  
  public func path() -> String {
    switch self {
      case .token:
        return "https://snip.picta-hub.io/github-token"
      case .user:
        return "https://api.github.com/user"
      case .gists:
        return "https://api.github.com/gists"
      case .getGist(let id), .updateGist(let id):
        return "https://api.github.com/gists/\(id)"
    }
  }
}

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
  case createGist
  case getGist(id: String)
  
  public func path() -> String {
    switch self {
    case .token:
      return "https://github.com/login/oauth/access_token"
    case .user:
      return "https://api.github.com/user"
    case .createGist:
      return "https://api.github.com/gists"
    case .getGist(let id):
      return "https://api.github.com/gists/\(id)"
    }
  }
}

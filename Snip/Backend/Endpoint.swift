//
//  Endpoint.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/13/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation


public enum Endpoint {
  
  case oauth
  case createGist
  case getGist(id: String)
  
  public func path() -> String {
    switch self {
    case .oauth:
      return "https://github.com/login/oauth/authorize"
    case .createGist:
      return "https://api.github.com/gists"
    case .getGist(let id):
      return "https://api.github.com/gists/\(id)"
    }
  }
}

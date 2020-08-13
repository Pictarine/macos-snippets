//
//  APIManager.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/13/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation


class APIManager {
  
  static let oauthURL = URL(string: "https://github.com/login/oauth/authorize?client_id=c4fd4a181bfc4089385b&redirect_uri=snip://oauth/callback&scope=gist,user&state=snip")!
  
}

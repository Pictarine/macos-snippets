//
//  APIManager.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/13/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import Combine


class SyncManager: ObservableObject {
  
  public static let shared = SyncManager()
  
  @Published var isAuthenticated = false
  @Published var connectedUser : User?
  
  var stores: Set<AnyCancellable> = []
  var oauth : Oauth?
  
  private let clientId = "c4fd4a181bfc4089385b"
  private let clientSecret = "50273aed8a9f94cc7147cda776696b27207443e6"
  private let callbackURL = "snip://callback"
  static let oauthURL = URL(string: "https://github.com/login/oauth/authorize?client_id=c4fd4a181bfc4089385b&redirect_uri=snip://callback&scope=gist,user&state=snip")!
  
  func handleDeepLink(urls: [URL]) {
    let url = urls.first
    if let url = url,
      url.absoluteString.starts(with: callbackURL),
      let params = url.queryParameters{
      
      if let code = params["code"],
        let state = params["state"] {
          requestAccessToken(code: code, state: state)
      }
      else {
        print(url.absoluteString)
      }
      
    }
  }
  
  func requestAccessToken(code: String, state: String) {
    requestToken(code: code, state: state)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { (completion) in
        if case let .failure(error) = completion {
          print(error)
        }
      }, receiveValue: { [weak self] (oauth) in
        print(oauth.access_token)
        self?.oauth = oauth
        self?.isAuthenticated = true
        self?.requestUser()
      })
      .store(in: &stores)
  }
  
  func requestUser() {
    getUser()
    .receive(on: DispatchQueue.main)
    .sink(receiveCompletion: { (completion) in
      if case let .failure(error) = completion {
        print(error)
      }
    }, receiveValue: { [weak self] (user) in
      self?.connectedUser = user
    })
    .store(in: &stores)
  }
  
  func requestToken(code: String, state: String) -> AnyPublisher<Oauth, Error> {
    let params = [
      "client_id": clientId,
      "client_secret": clientSecret,
      "redirect_uri": callbackURL,
      "code": code,
      "state": state
    ]
    
    return API.run(Endpoint.token, HttpMethod.post, [:], params, [:], oauth)
  }
  
  func getUser() ->  AnyPublisher<User, Error> {
    
    let headerParam = [
      "Accept": "application/vnd.github.v3+json"
    ]
    
    return API.run(Endpoint.user, HttpMethod.get, [:], [:], headerParam, oauth)
  }
}

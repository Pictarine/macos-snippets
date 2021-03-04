//
//  OauthManager.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/13/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation
import Combine

public enum HttpMethod: String {
  case post = "POST"
  case get = "GET"
  case patch = "PATCH"
}

enum FailureReason : Error {
  case httpCallFailed(error: URLError)
  case decodingFailed
  case other(Error)
}


class API {
  
  let session = URLSession.shared
  
  static func run<T: Decodable>(_ endpoint: Endpoint,
                                _ httpMethod: HttpMethod,
                                _ params: [String: Any],
                                _ jsonBody: [String: Any],
                                _ headerParam: [String: String],
                                _ oauth: Oauth?,
                                _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, FailureReason> {
    
    var request = URLRequest(url: URL(string: "\(endpoint.path())?\(String(data: params.percentEncoded()!, encoding: .utf8) ?? "")")!)
    request.httpMethod = httpMethod.rawValue
    request.setValue("application/json", forHTTPHeaderField:"Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    if headerParam.count > 0 {
      for (key, value) in headerParam {
        request.setValue(value, forHTTPHeaderField: key)
      }
    }
    
    if let oauth = oauth {
      request.setValue("token \(oauth.access_token)", forHTTPHeaderField:"Authorization")
    }
    
    if jsonBody.count > 0 {
      request.httpBody = try? JSONSerialization.data(withJSONObject: jsonBody)
    }
    
    return URLSession.shared
      .dataTaskPublisher(for: request)
      .map(\.data)
      .handleEvents(receiveOutput: { (data) in
        print(String(data: data, encoding: .utf8)!)
      })
      .decode(type: T.self, decoder: decoder)
      .mapError({ error in
        switch error {
        case is Swift.DecodingError:
          return .decodingFailed
        case let urlError as URLError:
          return .httpCallFailed(error: urlError)
        default:
          return .other(error)
        }
      })
      .eraseToAnyPublisher()
  }
  
}

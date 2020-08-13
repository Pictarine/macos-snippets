//
//  CharacterSet.swift
//  Snip
//
//  Created by Anthony Fernandez on 8/13/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation


extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

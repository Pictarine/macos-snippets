//
//  CodeMode.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/30/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation


public struct CodeMode: Codable {
  
  let name: String
  let mimeType: String
  
}

public enum CodeModes {
  
  case apl
  case ascii
  case asn
  case cmake
  case c
  case cplus
  case objc
  case kotlin
  case scala
  case csharp
  case java
  case cobol
  case coffeescript
  case lisp
  case css
  case django
  case dockerfile
  case erlang
  case fortran
  case go
  case groovy
  case haskell
  case html
  case http
  case javascript
  case json
  case ecma
  case jinja
  case lua
  case markdown
  case math
  case pascal
  case perl
  case php
  case powershell
  case protobuf
  case python
  case r
  case ruby
  case rust
  case sass
  case scheme
  case shell
  case sql
  case sqllit
  case mysql
  case latex
  case swift
  case text
  case vb
  case vue
  case xml
  case yaml
}

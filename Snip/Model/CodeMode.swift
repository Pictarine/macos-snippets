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
  case pgp
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
  case typescript
  case json
  case ecma
  case jinja
  case lua
  case markdown
  case maths
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
  case sqllite
  case mysql
  case latex
  case swift
  case text
  case vb
  case vue
  case xml
  case yaml
  
  func mode() -> CodeMode {
    switch self {
    case .apl:
      return CodeMode(name: "APL", mimeType: "text/apl")
    case .pgp:
      return CodeMode(name: "PGP", mimeType: "application/pgp")
    case .asn:
      return CodeMode(name: "ASN", mimeType: "text/x-ttcn-asn")
    case .cmake:
      return CodeMode(name: "cmake", mimeType: "text/x-cmake")
    case .c:
      return CodeMode(name: "c", mimeType: "text/x-c")
    case .cplus:
      return CodeMode(name: "c++", mimeType: "text/x-c++src")
    case .objc:
      return CodeMode(name: "Objective-C", mimeType: "text/x-objectivec")
    case .kotlin:
      return CodeMode(name: "Kotlin", mimeType: "text/x-kotlin")
    case .scala:
      return CodeMode(name: "scala", mimeType: "text/x-scala")
    case .csharp:
      return CodeMode(name: "C#", mimeType: "text/x-csharp")
    case .java:
      return CodeMode(name: "java", mimeType: "text/x-java")
    case .cobol:
      return CodeMode(name: "cobol", mimeType: "text/x-cobol")
    case .coffeescript:
      return CodeMode(name: "coffeescript", mimeType: "text/coffeescript")
    case .lisp:
      return CodeMode(name: "lisp", mimeType: "text/x-common-lisp")
    case .css:
      return CodeMode(name: "css/scss", mimeType: "text/x-scss")
    case .django:
      return CodeMode(name: "django", mimeType: "text/x-django")
    case .dockerfile:
      return CodeMode(name: "dockerfile", mimeType: "text/x-dockerfile")
    case .erlang:
      return CodeMode(name: "erlang", mimeType: "text/x-erlang")
    case .fortran:
      return CodeMode(name: "fortran", mimeType: "text/x-fortran")
    case .go:
      return CodeMode(name: "go", mimeType: "text/x-go")
    case .groovy:
      return CodeMode(name: "groovy", mimeType: "text/x-groovy")
    case .haskell:
      return CodeMode(name: "haskell", mimeType: "text/x-haskell")
    case .html:
      return CodeMode(name: "html", mimeType: "text/html")
    case .http:
      return CodeMode(name: "http", mimeType: "message/http")
    case .javascript:
      return CodeMode(name: "javascript", mimeType: "application/javascript")
    case .typescript:
      return CodeMode(name: "typescript", mimeType: "application/typescript")
    case .json:
      return CodeMode(name: "JSON", mimeType: "application/json")
    case .ecma:
      return CodeMode(name: "ecma", mimeType: "application/ecmascript")
    case .jinja:
      return CodeMode(name: "jinja", mimeType: "jinja2")
    case .lua:
      return CodeMode(name: "lua", mimeType: "text/x-lua")
    case .markdown:
      return CodeMode(name: "markdown", mimeType: "text/markdown")
    case .maths:
      return CodeMode(name: "maths", mimeType: "text/x-mathematica")
    case .pascal:
      return CodeMode(name: "pascal", mimeType: "text/x-pascal")
    case .perl:
      return CodeMode(name: "perl", mimeType: "perl")
    case .php:
      return CodeMode(name: "php", mimeType: "application/x-httpd-php")
    case .powershell:
      return CodeMode(name: "powershell", mimeType: "application/x-powershell")
    case .protobuf:
      return CodeMode(name: "protobuf", mimeType: "text/x-protobuf")
    case .python:
      return CodeMode(name: "python", mimeType: "text/x-cython")
    case .r:
      return CodeMode(name: "R", mimeType: "text/x-rsrc")
    case .ruby:
      return CodeMode(name: "ruby", mimeType: "text/x-ruby")
    case .rust:
      return CodeMode(name: "rust", mimeType: "text/rust")
    case .sass:
      return CodeMode(name: "sass", mimeType: "text/x-sass")
    case .scheme:
      return CodeMode(name: "scheme", mimeType: "text/x-scheme")
    case .shell:
      return CodeMode(name: "shell", mimeType: "application/x-sh")
    case .sql:
      return CodeMode(name: "SQL", mimeType: "text/x-sql")
    case .sqllite:
      return CodeMode(name: "SQLlite", mimeType: "text/x-sqlite")
    case .mysql:
      return CodeMode(name: "mySQL", mimeType: "text/x-mysql")
    case .latex:
      return CodeMode(name: "latex", mimeType: "text/x-latex")
    case .swift:
      return CodeMode(name: "swift", mimeType: "text/x-swift")
    case .text:
      return CodeMode(name: "text", mimeType: "text/plain-text")
    case .vb:
      return CodeMode(name: "vb", mimeType: "text/x-vb")
    case .vue:
      return CodeMode(name: "Vue", mimeType: "text/x-vue")
    case .xml:
      return CodeMode(name: "xml", mimeType: "application/xml")
    case .yaml:
      return CodeMode(name: "yaml", mimeType: "text/yaml")
    }
  }
}

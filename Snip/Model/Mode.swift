//
//  CodeMode.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/30/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation


struct Mode: Equatable, Codable {

  let name: String
  let mimeType: String
  
}

extension Mode {
  
  var imageName : String {
    switch name {
    case "python", "jinja":
      return "code_python"
    case "javascript", "typescript", "vue":
      return "code_js"
    case "swift":
      return "code_swift"
    case "html":
      return "code_html"
    case "css/scss":
      return "code_css"
    case "dockerfile":
      return "code_docker"
    case "powershell", "shell", "cmake":
      return "code_terminal"
    case "xml", "json":
      return "code_xml"
    default:
      return "ic_file"
    }
  }
  
}

public enum CodeMode: String {
  
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
  
  static func list() -> [Mode] {
    var modesList = [
      CodeMode.apl.mode(),
      CodeMode.pgp.mode(),
      CodeMode.asn.mode(),
      CodeMode.cmake.mode(),
      CodeMode.c.mode(),
      CodeMode.cplus.mode(),
      CodeMode.objc.mode(),
      CodeMode.kotlin.mode(),
      CodeMode.scala.mode(),
      CodeMode.csharp.mode(),
      CodeMode.java.mode(),
      CodeMode.cobol.mode(),
      CodeMode.coffeescript.mode(),
      CodeMode.lisp.mode(),
      CodeMode.css.mode(),
      CodeMode.django.mode(),
      CodeMode.dockerfile.mode(),
      CodeMode.erlang.mode(),
      CodeMode.fortran.mode(),
      CodeMode.go.mode(),
      CodeMode.groovy.mode(),
      CodeMode.haskell.mode(),
      CodeMode.html.mode(),
      CodeMode.http.mode(),
      CodeMode.javascript.mode(),
      CodeMode.typescript.mode(),
      CodeMode.json.mode(),
      CodeMode.ecma.mode(),
      CodeMode.jinja.mode(),
      CodeMode.lua.mode(),
      CodeMode.markdown.mode(),
      CodeMode.maths.mode(),
      CodeMode.pascal.mode(),
      CodeMode.perl.mode(),
      CodeMode.php.mode(),
      CodeMode.powershell.mode(),
      CodeMode.protobuf.mode(),
      CodeMode.python.mode(),
      CodeMode.r.mode(),
      CodeMode.ruby.mode(),
      CodeMode.rust.mode(),
      CodeMode.sass.mode(),
      CodeMode.scheme.mode(),
      CodeMode.shell.mode(),
      CodeMode.sql.mode(),
      CodeMode.sqllite.mode(),
      CodeMode.mysql.mode(),
      CodeMode.latex.mode(),
      CodeMode.swift.mode(),
      CodeMode.text.mode(),
      CodeMode.vb.mode(),
      CodeMode.vue.mode(),
      CodeMode.xml.mode(),
      CodeMode.yaml.mode()
    ]
    
    modesList.sort {
      $0.name < $1.name
    }
    
    return modesList
  }
  
  func mode() -> Mode {
    switch self {
    case .apl:
      return Mode(name: "apl", mimeType: "text/apl")
    case .pgp:
      return Mode(name: "pgp", mimeType: "application/pgp")
    case .asn:
      return Mode(name: "asn", mimeType: "text/x-ttcn-asn")
    case .cmake:
      return Mode(name: "cmake", mimeType: "text/x-cmake")
    case .c:
      return Mode(name: "c", mimeType: "text/x-c")
    case .cplus:
      return Mode(name: "c++", mimeType: "text/x-c++src")
    case .objc:
      return Mode(name: "objective-c", mimeType: "text/x-objectivec")
    case .kotlin:
      return Mode(name: "kotlin", mimeType: "text/x-kotlin")
    case .scala:
      return Mode(name: "scala", mimeType: "text/x-scala")
    case .csharp:
      return Mode(name: "c#", mimeType: "text/x-csharp")
    case .java:
      return Mode(name: "java", mimeType: "text/x-java")
    case .cobol:
      return Mode(name: "cobol", mimeType: "text/x-cobol")
    case .coffeescript:
      return Mode(name: "coffeescript", mimeType: "text/coffeescript")
    case .lisp:
      return Mode(name: "lisp", mimeType: "text/x-common-lisp")
    case .css:
      return Mode(name: "css/scss", mimeType: "text/x-scss")
    case .django:
      return Mode(name: "django", mimeType: "text/x-django")
    case .dockerfile:
      return Mode(name: "dockerfile", mimeType: "text/x-dockerfile")
    case .erlang:
      return Mode(name: "erlang", mimeType: "text/x-erlang")
    case .fortran:
      return Mode(name: "fortran", mimeType: "text/x-fortran")
    case .go:
      return Mode(name: "go", mimeType: "text/x-go")
    case .groovy:
      return Mode(name: "groovy", mimeType: "text/x-groovy")
    case .haskell:
      return Mode(name: "haskell", mimeType: "text/x-haskell")
    case .html:
      return Mode(name: "html", mimeType: "text/html")
    case .http:
      return Mode(name: "http", mimeType: "message/http")
    case .javascript:
      return Mode(name: "javascript", mimeType: "application/javascript")
    case .typescript:
      return Mode(name: "typescript", mimeType: "application/typescript")
    case .json:
      return Mode(name: "json", mimeType: "application/json")
    case .ecma:
      return Mode(name: "ecma", mimeType: "application/ecmascript")
    case .jinja:
      return Mode(name: "jinja", mimeType: "jinja2")
    case .lua:
      return Mode(name: "lua", mimeType: "text/x-lua")
    case .markdown:
      return Mode(name: "markdown", mimeType: "text/markdown")
    case .maths:
      return Mode(name: "maths", mimeType: "text/x-mathematica")
    case .pascal:
      return Mode(name: "pascal", mimeType: "text/x-pascal")
    case .perl:
      return Mode(name: "perl", mimeType: "perl")
    case .php:
      return Mode(name: "php", mimeType: "application/x-httpd-php")
    case .powershell:
      return Mode(name: "powershell", mimeType: "application/x-powershell")
    case .protobuf:
      return Mode(name: "protobuf", mimeType: "text/x-protobuf")
    case .python:
      return Mode(name: "python", mimeType: "text/x-cython")
    case .r:
      return Mode(name: "r", mimeType: "text/x-rsrc")
    case .ruby:
      return Mode(name: "ruby", mimeType: "text/x-ruby")
    case .rust:
      return Mode(name: "rust", mimeType: "text/rust")
    case .sass:
      return Mode(name: "sass", mimeType: "text/x-sass")
    case .scheme:
      return Mode(name: "scheme", mimeType: "text/x-scheme")
    case .shell:
      return Mode(name: "shell", mimeType: "application/x-sh")
    case .sql:
      return Mode(name: "sql", mimeType: "text/x-sql")
    case .sqllite:
      return Mode(name: "sqllite", mimeType: "text/x-sqlite")
    case .mysql:
      return Mode(name: "mysql", mimeType: "text/x-mysql")
    case .latex:
      return Mode(name: "latex", mimeType: "text/x-latex")
    case .swift:
      return Mode(name: "swift", mimeType: "text/x-swift")
    case .text:
      return Mode(name: "text", mimeType: "text/plain-text")
    case .vb:
      return Mode(name: "vb", mimeType: "text/x-vb")
    case .vue:
      return Mode(name: "vue", mimeType: "text/x-vue")
    case .xml:
      return Mode(name: "xml", mimeType: "application/xml")
    case .yaml:
      return Mode(name: "yaml", mimeType: "text/yaml")
    }
  }
}

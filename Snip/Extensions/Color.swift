//
//  Color.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//


import Foundation
import SwiftUI
import Cocoa

extension Color {
  
  static let BLACK_200 = Color.init(hex: "23252e")
  static let BLACK_300 = Color.init(hex: "212121")
  static let BLACK_500 = Color.init(hex: "282A36")
  
  static let PINK_500 = Color.init(hex: "FE7AC6")
  
  static let GREEN_500 = Color.init(hex: "4FFA7B")
  
  static let YELLOW_500 = Color.init(hex: "F2FA8C")
  
  static let PURPLE_500 = Color.init(hex: "bd93f9")
  
  static let RED_500 = Color.init(hex: "ff5555")
  
  static let ORANGE_500 = Color.init(hex: "E5946A")
  
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (1, 1, 1, 0)
    }
    
    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue:  Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
}


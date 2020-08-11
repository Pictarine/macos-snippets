//
//  Date.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import Foundation


extension Date {
  
  func toStringFormatted() -> String {
      let format = "yyyy-MM-dd"
      let formatter = DateFormatter()
      formatter.dateStyle = .short
      formatter.dateFormat = format
      return formatter.string(from: self)
  }
  
  static func toDate(strDate: String) -> Date {
    let format = "yyyy-MM-dd"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.date(from: strDate)!
  }
  
  func dateAndTimetoString() -> String {
      let format: String = "yyyy-MM-dd HH:mm:ss"
      let formatter = DateFormatter()
      formatter.dateStyle = .short
      formatter.dateFormat = format
      return formatter.string(from: self)
  }
  
  func nextDate() -> Date {
      let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: self)
      return nextDate ?? Date()
  }
  
  func previousDate() -> Date {
      let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: self)
      return previousDate ?? Date()
  }
  
  func getHumanReadableDayString() -> String {
      let weekdays = [
          "Sunday",
          "Monday",
          "Tuesday",
          "Wednesday",
          "Thursday",
          "Friday",
          "Saturday"
      ]
      
      let calendar = Calendar.current.component(.weekday, from: self)
      return weekdays[calendar - 1]
  }
}

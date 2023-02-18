//
//  CalendarHelper.swift
//  Calendar
//
//  Created by Mekhriddin on 09/07/22.
//

import UIKit

class CalendarHelper {
    
    let calendar = Calendar(identifier: .gregorian)
    
    func plusMonth(date: Date) -> Date{
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func minusMonth(date: Date) -> Date{
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func monthString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "LLLL"   // gives month name in full string format like "February"
        return dateFormatter.string(from: date).capitalized
    }
    
    func yearString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "yyyy"   // gives year like "2022"
        return dateFormatter.string(from: date)
    }
    
    func daysInMonth(date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)
        return range!.count
    }
    
    func daysOfMonth(date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!             // gives days like "2" or "28"
    }
    
    func firstDayOfMonth(date: Date) -> Date {
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))
        return firstDayOfMonth!
    }
    
    func weekDay(date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        if components.weekday! == 1 {
            return 6
        }
        return components.weekday! - 2          // "Friday" -> 5
    }
    
    
    func LastDayOfPreviousMonth(date: Date) -> Date {
        let lastDayInMonth = calendar.date(byAdding: DateComponents(day: -1), to: date)
        return lastDayInMonth!
    }
    
    
    func nextDay(date: Date, next: Int) -> Date {
        let lastDayInMonth = calendar.date(byAdding: DateComponents(day: next), to: date)
        return lastDayInMonth!
    }
  
}


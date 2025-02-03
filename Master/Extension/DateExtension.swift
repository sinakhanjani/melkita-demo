//
//  DateExtension.swift
//  Master
//
//  Created by Sinakhanjani on 10/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

extension Date {
    
    func PersianDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: .persian)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self)
    }
    
    func englishDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        return dateFormatter.string(from: self)
    }
    
    static func behind(exDate: Date) -> String {
        var str = ""
        let nowDate = Date()
        let day = exDate.days(from: nowDate)+1
        var minute = 0
        var hour = 0

        if day > 0 {
            hour = exDate.hours(from: nowDate) - ((day-1)*24)

            //3353 < 1440
            minute = exDate.minutes(from: nowDate) // minute
            str = "\(-(day-1))"

            if hour < 24 {
                if minute < 1440 { //1440 ---- 393-((7-1)*60)
                    minute = minute-(hour*60)
                    str += ""
                }
            }
        }
        if day <= 0 {
            hour = exDate.hours(from: nowDate) - ((1-1)*24)
            str = "\(-(day-1))"

            //3353 < 1440
            minute = exDate.minutes(from: nowDate) // minute
            if hour < 24 {
                if minute < 1440 { //1440 ---- 393-((7-1)*60)
                    minute = minute-(hour*60)
                    str += ""
                }
            }
        }
        
        return str + " " + "روز پیش"
    }
}

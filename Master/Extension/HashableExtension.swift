//
//  HashableExtension.swift
//  Alaedin
//
//  Created by Sinakhanjani on 10/23/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

extension String {
    
    func persianDate() -> String? {
        let dateFormatter = DateFormatter()
//        let dateFormatter = ISO8601DateFormatter()
        //2021-07-20T16:59:47.0041393
        //2021-04-29T20:37:07.830Z
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS" //2021-04-29T20:37:07.830Z
//        dateFormatter.calendar = Calendar(identifier: .persian)
//        dateFormatter.locale = Locale(identifier: "fa_IR")
        
//        let dateString = "2021-04-29T20:37:07.830Z"
//        let trimmedIsoString = dateString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        
        if let persianDate = dateFormatter.date(from: self) {
            let persianDateFormatter = DateFormatter()
            persianDateFormatter.calendar = Calendar(identifier: .persian)
            persianDateFormatter.dateFormat = "yyyy/MM/dd hh:mm" //HH:mm:ss
            
            return persianDateFormatter.string(from: persianDate)
        }
        // Date
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //2021-04-29T20:37:07.830Z
        if let persianDate = dateFormatter.date(from: self) {
            let persianDateFormatter = DateFormatter()
            persianDateFormatter.calendar = Calendar(identifier: .persian)
            persianDateFormatter.dateFormat = "yyyy/MM/dd hh:mm" //HH:mm:ss
            
            return persianDateFormatter.string(from: persianDate)
        }
        
        return nil
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
//        let dateFormatter = ISO8601DateFormatter()
        //2021-07-20T16:59:47.0041393
        //2021-04-29T20:37:07.830Z
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS" //2021-04-29T20:37:07.830Z .SSSSSSS
//        dateFormatter.calendar = Calendar(identifier: .persian)
//        dateFormatter.locale = Locale(identifier: "fa_IR")
        
//        let dateString = "2021-04-29T20:37:07.830Z"
//        let trimmedIsoString = dateString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        if let x = dateFormatter.date(from: self) {
            return x
        }
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //2021-04-29T20:37:07.830Z .SSSSSSS
        if let x = dateFormatter.date(from: self) {
            return x
        }
        
        return nil
    }

    func persianDateWithFormat(_ format: String) -> String? {
        let dateFormatter = DateFormatter()
//        let dateFormatter = ISO8601DateFormatter()
        //2021-07-20T16:59:47.0041393
        //2021-04-29T20:37:07.830Z
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS" //2021-04-29T20:37:07.830Z
//        dateFormatter.calendar = Calendar(identifier: .persian)
//        dateFormatter.locale = Locale(identifier: "fa_IR")
        
//        let dateString = "2021-04-29T20:37:07.830Z"
//        let trimmedIsoString = dateString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        
        if let persianDate = dateFormatter.date(from: self) {
            let persianDateFormatter = DateFormatter()
            persianDateFormatter.calendar = Calendar(identifier: .persian)
            persianDateFormatter.dateFormat = format //HH:mm:ss
            
            return persianDateFormatter.string(from: persianDate)
        } // Date
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //2021-04-29T20:37:07.830Z
        if let persianDate = dateFormatter.date(from: self) {
            let persianDateFormatter = DateFormatter()
            persianDateFormatter.calendar = Calendar(identifier: .persian)
            persianDateFormatter.dateFormat = format //HH:mm:ss
            
            return persianDateFormatter.string(from: persianDate)
        }
        
        return nil
    }
    
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    func makeACall() {
        if isValid(regex: .phone) {
            if let url = URL(string: "tel://\(self.onlyDigits())"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
}

extension String {
    
    var seperateByCama: String {
        guard self != "0" && self != "" && self != "0.00" && self != "0.0" else { return "0" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let nsNumber = NSNumber(value: Int(self)!)
        let number = formatter.string(from: nsNumber)!
        
        return number
    }
    
    
    
}

extension Int {
    var seperateByCama: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let nsNumber = NSNumber(value: self)
        let number = formatter.string(from: nsNumber)!
        return number
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

public extension Sequence where Element: Equatable {
    var uniqueElements: [Element] {
        return self.reduce(into: []) {
            uniqueElements, element in
            
            if !uniqueElements.contains(element) {
                uniqueElements.append(element)
            }
        }
    }
}

extension Int {
    var convertToPersian:String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "fa_IR")
        formatter.currencySymbol=""
        if (self != 0) {
            return "\(formatter.string(from: self as NSNumber) ?? "")"
            
        } else {
            return ""
        }
    }
}

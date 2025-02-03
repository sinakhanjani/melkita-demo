//
//  Constant.swift
//  Master
//
//  Created by Sinakhanjani on 10/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class Constant {
    
    struct Notify {
        static let dismissIndicatorViewControllerNotify = Notification.Name("dismissIndicatorViewController")
        static let LanguageChangedNotify = Notification.Name("englishLanguageChangedNotify")
        static let dropNotify = Notification.Name("dropNotify")
        static let bankNotify = Notification.Name("bankNotify")
    }
    
    struct Fonts {
        static let fontOne = "IRANSans"
        static let fontTwo = "IRANSansMobileFaNum-Bold"
        static let fontThree = "WeblogmaYekan"
        static let casablancaRegular = "Mj_Casablanca"
    }
    
    struct Google {
        static let api = "GOOGLE MAP API KEY"
    }
    
    struct Color {
        static let green = #colorLiteral(red: 0, green: 0.7251975536, blue: 0.6760455966, alpha: 1)
        static let dark = #colorLiteral(red: 0.4823101163, green: 0.4823812246, blue: 0.4822877049, alpha: 1)
    }
    
    enum Alert {
        case none, failed, success, json
    }
    
    enum Language {
        case fa, en
    }
    
}

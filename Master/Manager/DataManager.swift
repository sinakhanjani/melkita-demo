//
//  DataManager.swift
//  Master
//
//  Created by Sinakhanjani on 10/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class DataManager {
    
    static let shared = DataManager()

    var auth: Authentication = .user
    
    public var refreshToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "REFRESH_TOKEN")
        }
        set {
            
            UserDefaults.standard.setValue(newValue, forKey: "REFRESH_TOKEN")
        }
    }
    
    public var userProfile: LoginMobleReceived? {
        get {
            guard let string = UserDefaults.standard.string(forKey: "USER_VERIFICATION"),
                let data = string.data(using: .utf8) else {
                    return nil
            }
            return try? JSONDecoder().decode(LoginMobleReceived.self, from: data)
        }
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.set(nil, forKey: "USER_VERIFICATION")
                return
            }
            let data = try! JSONEncoder().encode(newValue)
            let string = String(data: data, encoding: .utf8)
            UserDefaults.standard.set(string, forKey: "USER_VERIFICATION")
        }
    }
    
    var notif: Notif?
    
    var setting: RCSetting?
    
    var role: RoleEnum?
    
    var documentStatus: DocumentStatus?
    var isApproveDocument: Bool {
        if let doc = documentStatus {
            if ((doc.documentUnApproved?.isEmpty ?? true) && (doc.documentPending?.isEmpty ?? true)) || ((doc.isApprove == true) && (doc.isPending == false)) { // is empty
                return true
            } else {
                return false
            }
        }
        
        return false
    }
    var isAccountApprive: Bool {
        if let doc = documentStatus {
            if (doc.isAccountApprove ?? false) {
                return true
            }
        }
        return false
    }
    
    
    var userInfo: RCUserInfo?
//    var isExpiredPackage: Bool {
//        if let userInfo = userInfo {
//            let today = Date()
//            if let exDate = userInfo.expireMarketerAccountDate?.toDate() {
//                if today >= exDate {
//                    return true
//                } else {
//                    return false
//                }
//            }
//        }
//        return true
//    }
    var isExpiredBetweenXDayFromNow: Bool {
        if let userInfo = userInfo {
            let today = Date()
            if let exAfter5Date = userInfo.expireMarketerAccountAfterDate?.toDate(), let exDate = userInfo.expireMarketerAccountDate?.toDate() {
                print(exAfter5Date, exDate)
                if (today < exAfter5Date) && (today > exDate) {
                    return true
                } else {
                    return false
                }
            }
        }
        
        return false
    }
    var hasMarketerPackage: Bool {
        if let userInfo = userInfo {
            if let exDate = userInfo.expireMarketerAccountDate?.toDate() {
                if Date() < exDate {
                    return true
                }
            }
        }
        return false
    }
    
    var hasMarketerPackageAfter: Bool {
        if let userInfo = userInfo {
            if let exDate = userInfo.expireMarketerAccountAfterDate?.toDate() {
                if Date() < exDate {
                    return true
                }
            }
        }
        return false
    }
}

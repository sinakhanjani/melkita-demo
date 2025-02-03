//
//  Enum.swift
//  Master
//
//  Created by Sina khanjani on 4/25/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import Foundation

public enum GateWayPaymentEnum: Int, CaseIterable
{
    case Mellat = 1
    case Zarinpal = 2
    case Jibit = 3
    case Melli = 4
    case Parsian = 5
    case Sepehr = 6
    case Jeeb = 100
}

public enum OrderTypeEnum: Int
{
    case InfoEstatatePhone = 1
    case LadderEstate = 2
    case VipEstate = 3
    case AddEstate = 4
    case ExEstate = 5
    case DiscountPackage = 6
    case IncInventoryWallet = 7
}


public enum PaymentMethodEnum: Int
{
    case Online = 1
    case DiscountPackage = 2
    case  Wallet = 3
}




// MARK: - RCBankModelElement
struct RCBankModelElement: Codable {
    let title: String
    let key: Int
}


// MARK: - RCPaymentModel
struct RCInventory: Codable {
    let inventory: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case inventory
        
    }
}


// MARK: - RCDiscountElement
struct RCPackageItem: Codable {
    let id, title, userID, packageID: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case userID = "userId"
        case packageID = "packageId"
    }
}

typealias RCPackageItems = [RCPackageItem]

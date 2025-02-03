////
////  AgahiModel.swift
////  Master
////
////  Created by Sina khanjani on 3/28/1400 AP.
////  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
////
//
//import Foundation
//
// MARK: - EstateTypeModel
struct AgahiModel: Codable {
    let type: Int?
    let userID, title, estateTypeModelDescription: String?
    let provinceID, cityID: Int?
    let estateUseID, estateTypeID: String?
    let metr: Int
//    let age: JSONNull?
    let isNewAge: Bool?
    let priceBuy, priceRent, priceMortgage: Int?
    let isMortgage, isAgreementPriceBuy, isAgreementPriceRent, isAgreementPriceMortgage: Bool?
    let latitude, longitude: Double?
    let countRoom: Int?
    let address: String?
    let key: Int?
//    let videoID:JSONNull?
    let videoURL: String?
    let isFree, isFreeAdd: Bool?
    let status: Int?
    let isAdmin, isUpdated, isLadder, isSold: Bool?
    let visitCount: Int?
    let age: Int?
//    let messageFailed: JSONNull?
    let phoneNumber: String?
//    let reasonForDeleted, ladderExpireDate, ladderDate: JSONNull?
    let isVip: Bool?
//    let vipExpireDate, vipDate, expireDate: JSONNull?
    let isDelete: Bool?
    let updatedDate: String?
    let user: User?
    let useTypeEstate: UseType?
    let estateType: EstateType?
    let province, city: City?
    let features: [FeatureElement]?
    let conditions: [ConditionElement]?
    let pictures, estateVisits: [EstateVisit]?
    
    let buildingPositionEstate: [RCBuildtingS]?
    let viewTypeBuildingEstate: [RCViewS]?
    let buildingDocument:  BuildingDoc?
    let buildingStructureType: BuildingDoc?
//    let boxCustom, estatePayUsers, orders, favo: JSONNull?
//    let video, tickets, logs: JSONNull?
    let id, createDate, modifiedDate: String?

    enum CodingKeys: String, CodingKey {
        case buildingPositionEstate,viewTypeBuildingEstate,buildingDocument,buildingStructureType
        case age
        case type
        case userID = "userId"
        case title
        case estateTypeModelDescription = "description"
        case provinceID = "provinceId"
        case cityID = "cityId"
        case estateUseID = "estateUseId"
        case estateTypeID = "estateTypeId"
        case metr
//             case age
                  case isNewAge, priceBuy, priceRent, priceMortgage, isMortgage, isAgreementPriceBuy, isAgreementPriceRent, isAgreementPriceMortgage, latitude, longitude, countRoom, address, key
//        case videoID = "videoId"
        case videoURL = "videoUrl"
        case isFree, isFreeAdd, status, isAdmin, isUpdated, isLadder, isSold, visitCount, phoneNumber
//             case reasonForDeleted, ladderExpireDate, ladderDate
                  case isVip
//             case vipExpireDate, vipDate, expireDate
                  case isDelete, updatedDate, user, useTypeEstate, estateType, province, city, features, conditions, pictures, estateVisits
//             case boxCustom, estatePayUsers, orders, favo
//             case video, tickets, logs
                  case id, createDate, modifiedDate
    }
}
//
//// MARK: - City
//struct City: Codable {
//    let id: Int
//    let province: Int?
//    let name: String
//    let latitude, longitude: Double
//    let isActive, isDelete: Bool
//    let modifiedDate: String
//    let estate: [JSONAny]
//    let cityAccessUser: JSONNull?
//    let country: Int?
//    let accesss, provinceAccessUser: JSONNull?
//}
//
// MARK: - ConditionElement
struct ConditionElement: Codable {
    let estateID, conditionID: String?
    let condition: ConditionCondition?
    let id, createDate, modifiedDate: String?

    enum CodingKeys: String, CodingKey {
        case estateID = "estateId"
        case conditionID = "conditionId"
        case condition, id, createDate, modifiedDate
    }
}
//
// MARK: - ConditionCondition
struct ConditionCondition: Codable {
    let title: String?
    let type: Int?
    let isDelete: Bool?
//    let conditionEstates: [JSONAny]
    let id, createDate, modifiedDate: String?
}
//
// MARK: - UseType
struct UseType: Codable {
    let title: String?
    let isDelete, isFreeAddEstate: Bool?
    let addEstatePrice: Int?
    let isFreePhoneEstate: Bool?
    let phoneEstatePrice: Int?
//    let estates: [JSONAny]
    let estateTypes: [EstateType]
    let id, createDate, modifiedDate: String?
}
//
// MARK: - EstateType
struct EstateType: Codable {
    let estateUseTypeID, title: String?
    let isDelete: Bool?
    let useType: UseType?
//    let estates: [JSONAny]
    let id, createDate, modifiedDate: String?

    enum CodingKeys: String, CodingKey {
        case estateUseTypeID = "estateUseTypeId"
        case title, isDelete, useType
//        case estates
        case id, createDate, modifiedDate
    }
}
//
// MARK: - EstateVisit
struct EstateVisit: Codable {
    let ipAddress: String?
    let estateID, id, createDate, modifiedDate: String?
    let picURL: String?

    enum CodingKeys: String, CodingKey {
        case ipAddress
        case estateID = "estateId"
        case id, createDate, modifiedDate
        case picURL = "picUrl"
    }
}
//
// MARK: - FeatureElement
struct FeatureElement: Codable {
    let estateID, featureID: String?
    let feature: FeatureFeature?
    let id, createDate, modifiedDate: String?

    enum CodingKeys: String, CodingKey {
        case estateID = "estateId"
        case featureID = "featureId"
        case feature, id, createDate, modifiedDate
    }
}

// MARK: - FeatureFeature
struct FeatureFeature: Codable {
    let title: String?
    let isDelete: Bool?
//    let featuresEstates: [JSONAny]
    let id, createDate, modifiedDate: String?
}
//
//// MARK: - User
struct User: Codable {
    let isAdminRegister: Bool?
//    let postID, provinceID, cityID: JSONNull?
    let firstName: String?
    let key: Int?
//    let identifierCode: JSONNull?
    let lastName: String?
//    let companyName: JSONNull?
    let isAdvisor: Bool?
//    let phoneCenter, photoURL: JSONNull?
    let isActive, isDelete, isDocument, isApprove: Bool?
    let editedProfileStatus: Int?
//    let logGroup, messageFailedEditedProfile: JSONNull?
    let approveRules: Bool?
    let nationalCode: String?
    let inventory, credit: Int?
//    let latitude, longitude, modifiedDate: JSONNull?
    let createDate: String?
//    let roles: JSONNull?
//    let estate: [JSONAny]
//    let content, commentContent, estatePayUsers, orders: JSONNull?
//    let favo, document, documentUser, message: JSONNull?
//    let videos, discountPackageUser, profitMarketer, discountAdvisor: JSONNull?
//    let marketerBuy, marketerUser, deposit, bankCards: JSONNull?
//    let post, access, permission, provinceAccessUser: JSONNull?
//    let cityAccessUser, shiftWorkEmployee, marketerIntroDiscount, contentVideo: JSONNull?
//    let logs, chatSender, chatRecive, chatMessages: JSONNull?
    let id, userName, normalizedUserName, email: String?
    let normalizedEmail: String?
    let emailConfirmed: Bool?
    let passwordHash, securityStamp, concurrencyStamp, phoneNumber: String?
    let phoneNumberConfirmed, twoFactorEnabled: Bool?
    let lockoutEnabled: Bool?
    let accessFailedCount: Int?

    enum CodingKeys: String, CodingKey {
//        case postID = "postId"
//        case provinceID = "provinceId"
//        case cityID = "cityId"
//        case photoURL = "photoUrl"
        case isAdminRegister,firstName,key,lastName,isAdvisor
        case isActive, isDelete, isDocument, isApprove
        case editedProfileStatus
        case approveRules
        case nationalCode
        case inventory, credit
        case createDate
        case id, userName, normalizedUserName, email
        case normalizedEmail
        case emailConfirmed
        case passwordHash, securityStamp, concurrencyStamp, phoneNumber
        case phoneNumberConfirmed, twoFactorEnabled, lockoutEnabled, accessFailedCount
    }
}





// MARK: - RCPaymentModel
struct RCPaymentModel: Codable {
    let urlPay: String?
    let isFree, isPay: Bool?
    let id: String?
    let photoURL, phoneNumber, email, userName: String?
    let name: String?
    let phoneCenter, companyName: String?
    var priceAdvertising, key: Int?
    let title: String?
    let firstName, lastName: String?
    var priceAdvertisingDiscount: Int?
    
    init(price: Int?, discountPrice: Int?) {
        priceAdvertising = price
        priceAdvertisingDiscount = discountPrice
        self.urlPay = nil
        self.isFree = nil
        self.isPay = nil
        self.id = nil
        self.photoURL = nil
        self.phoneNumber = nil
        self.email = nil
        self.userName = nil
        self.name = nil
        self.phoneCenter = nil
        self.companyName = nil
        self.key = nil
        self.title = nil
        self.firstName = nil
        self.lastName = nil
    }
    
    init(urlPay: String?, isFree: Bool?, isPay: Bool?, id: String?, photoURL: String?, phoneNumber: String?, email: String?, userName: String?, name: String?, phoneCenter: String?, companyName: String?, priceAdvertising: Int? = nil, key: Int? = nil, title: String?, firstName: String?, lastName: String?, priceAdvertisingDiscount: Int? = nil) {
        self.urlPay = urlPay
        self.isFree = isFree
        self.isPay = isPay
        self.id = id
        self.photoURL = photoURL
        self.phoneNumber = phoneNumber
        self.email = email
        self.userName = userName
        self.name = name
        self.phoneCenter = phoneCenter
        self.companyName = companyName
        self.priceAdvertising = priceAdvertising
        self.key = key
        self.title = title
        self.firstName = firstName
        self.lastName = lastName
        self.priceAdvertisingDiscount = priceAdvertisingDiscount
    }
    
    enum CodingKeys: String, CodingKey {
        case urlPay, isFree, isPay, id
        case photoURL = "photoUrl"
        case phoneNumber, email, userName, name, phoneCenter, companyName, priceAdvertising, key, title, firstName, lastName
        case priceAdvertisingDiscount
    }
}

// MARK: - RCDiscount
struct RCDiscount: Codable {
    let isSuccess: Bool?
    let msg: String?
    let priceEnd, price, priceDiscount: Int?
    let priceEndShow: String?
}


// MARK: - RCSend
struct RCBuildtingS: Codable {
    let estateID, buildingPositionID: String?
    let buildingPosition: BuildingPosition?

    enum CodingKeys: String, CodingKey {
        case estateID = "estateId"
        case buildingPositionID = "buildingPositionId"
        case buildingPosition
    }
}

// MARK: - BuildingPosition
struct BuildingPosition: Codable {
    let title, id: String?
}


// MARK: - RCSend
struct RCViewS: Codable {
    let viewTypeBuildingID: String?
    let viewTypeBuilding: ViewTypeBuilding?

    enum CodingKeys: String, CodingKey {
        case viewTypeBuildingID = "viewTypeBuildingId"
        case viewTypeBuilding
    }
}

// MARK: - ViewTypeBuilding
struct ViewTypeBuilding: Codable {
    let title: String?
    var id: String?
}

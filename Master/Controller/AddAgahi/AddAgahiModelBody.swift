//
//  AddAgahiModelBody.swift
//  Master
//
//  Created by Sina khanjani on 4/27/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import Foundation

// MARK: - AddAgahiModelBody
struct AddAgahiModelBody: Codable {
    internal init(type: Int? = nil, buildingDocumentID: String? = nil, buildingStructureTypeID: String? = nil, title: String? = nil, addAgahiModelBodyDescription: String? = nil, provinceID: Int? = nil, cityID: Int? = nil, estateUseID: String? = nil, metr: Int? = nil, estateTypeID: String? = nil, age: Int? = nil, isNewAge: Bool? = nil, priceBuy: Int? = nil, priceRent: Int? = nil, priceMortgage: Int? = nil, isMortgage:  Bool = false, isAgreementPriceBuy: Bool = false, isAgreementPriceRent: Bool = false, isAgreementPriceMortgage: Bool = false, countRoom: Int? = nil, featureIDS: [String]? = nil, conditionIDS: [String]? = nil, buildingPositionIDS: [String]? = nil, viewTypeBuildingIDS: [String]? = nil, latitude: Double? = nil, longitude: Double? = nil, address: String? = nil, videoID: String? = nil, phoneNumber: String? = nil, pics: [String]? = nil) {
        self.type = type
        self.buildingDocumentID = buildingDocumentID
        self.buildingStructureTypeID = buildingStructureTypeID
        self.title = title
        self.addAgahiModelBodyDescription = addAgahiModelBodyDescription
        self.provinceID = provinceID
        self.cityID = cityID
        self.estateUseID = estateUseID
        self.metr = metr
        self.estateTypeID = estateTypeID
        self.age = age
        self.isNewAge = isNewAge
        self.priceBuy = 0
        self.priceRent = 0
        self.priceMortgage = 0
        self.isMortgage = isMortgage
        self.isAgreementPriceBuy = isAgreementPriceBuy
        self.isAgreementPriceRent = isAgreementPriceRent
        self.isAgreementPriceMortgage = isAgreementPriceMortgage
        self.countRoom = countRoom
        self.featureIDS = featureIDS
        self.conditionIDS = conditionIDS
        self.buildingPositionIDS = buildingPositionIDS
        self.viewTypeBuildingIDS = viewTypeBuildingIDS
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.videoID = videoID
        self.phoneNumber = phoneNumber
        self.pics = pics
    }
    
    var type: Int?
    var buildingDocumentID, buildingStructureTypeID, title, addAgahiModelBodyDescription: String?
    var provinceID, cityID: Int?
    var estateUseID: String?
    var metr: Int?
    var estateTypeID: String?
    var age: Int?
    var isNewAge: Bool?
    var priceBuy, priceRent, priceMortgage: Int?
    var isMortgage, isAgreementPriceBuy, isAgreementPriceRent, isAgreementPriceMortgage: Bool?
    var countRoom: Int?
    var featureIDS, conditionIDS, buildingPositionIDS, viewTypeBuildingIDS: [String]?
    var latitude, longitude: Double?
    var address, videoID, phoneNumber: String?
    var pics: [String]?

    enum CodingKeys: String, CodingKey {
        case type
        case buildingDocumentID = "buildingDocumentId"
        case buildingStructureTypeID = "buildingStructureTypeId"
        case title
        case addAgahiModelBodyDescription = "description"
        case provinceID = "provinceId"
        case cityID = "cityId"
        case estateUseID = "estateUseId"
        case metr
        case estateTypeID = "estateTypeId"
        case age, isNewAge, priceBuy, priceRent, priceMortgage, isMortgage, isAgreementPriceBuy, isAgreementPriceRent, isAgreementPriceMortgage, countRoom
        case featureIDS = "featureIds"
        case conditionIDS = "conditionIds"
        case buildingPositionIDS = "buildingPositionIds"
        case viewTypeBuildingIDS = "viewTypeBuildingIds"
        case latitude, longitude, address
        case videoID = "videoId"
        case phoneNumber, pics
    }
}


// MARK: - AddAgahiModelBody
struct AddAgahiStatus: Codable {
    let categoryID: String?
    let isFreeAddEstate: Bool?
    let addEstatePrice, discountPrice: Int?

    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case isFreeAddEstate, addEstatePrice, discountPrice
    }
}




// MARK: - TamdidAgahiModel
struct TamdidAgahiModel: Codable {    
    
    init(addAgahi: AddAgahiModelBody, estateID: String) {
        self.id = estateID
        self.buildingDocumentID = addAgahi.buildingDocumentID
        self.buildingStructureTypeID = addAgahi.buildingStructureTypeID
        self.title = addAgahi.title
        self.tamdidAgahiModelDescription = addAgahi.addAgahiModelBodyDescription
        self.provinceID = addAgahi.provinceID
        self.cityID = addAgahi.cityID
        self.metr = addAgahi.metr
        self.age = addAgahi.age
        self.isNewAge = addAgahi.isNewAge
        self.priceBuy = addAgahi.priceBuy
        self.priceRent = addAgahi.priceRent
        self.priceMortgage = addAgahi.priceMortgage
        self.isMortgage = addAgahi.isMortgage
        self.isAgreementPriceBuy = addAgahi.isAgreementPriceBuy
        self.isAgreementPriceRent = addAgahi.isAgreementPriceRent
        self.isAgreementPriceMortgage = addAgahi.isAgreementPriceMortgage
        self.countRoom = addAgahi.countRoom
        self.featureIDS = addAgahi.featureIDS
        self.conditionIDS = addAgahi.conditionIDS
        self.buildingPositionIDS = addAgahi.buildingPositionIDS
        self.viewTypeBuildingIDS = addAgahi.viewTypeBuildingIDS
        self.latitude = addAgahi.latitude
        self.longitude = addAgahi.longitude
        self.address = addAgahi.address
        self.videoID = addAgahi.videoID
        self.phoneNumber = addAgahi.phoneNumber
    }
    
    let id, buildingDocumentID, buildingStructureTypeID, title: String?
    let tamdidAgahiModelDescription: String?
    let provinceID, cityID, metr, age: Int?
    let isNewAge: Bool?
    let priceBuy, priceRent, priceMortgage: Int?
    let isMortgage, isAgreementPriceBuy, isAgreementPriceRent, isAgreementPriceMortgage: Bool?
    let countRoom: Int?
    let featureIDS, conditionIDS, buildingPositionIDS, viewTypeBuildingIDS: [String]?
    let latitude, longitude: Double?
    let address, videoID, phoneNumber: String?

    enum CodingKeys: String, CodingKey {
        case id
        case buildingDocumentID = "buildingDocumentId"
        case buildingStructureTypeID = "buildingStructureTypeId"
        case title
        case tamdidAgahiModelDescription = "description"
        case provinceID = "provinceId"
        case cityID = "cityId"
        case metr, age, isNewAge, priceBuy, priceRent, priceMortgage, isMortgage, isAgreementPriceBuy, isAgreementPriceRent, isAgreementPriceMortgage, countRoom
        case featureIDS = "featureIds"
        case conditionIDS = "conditionIds"
        case buildingPositionIDS = "buildingPositionIds"
        case viewTypeBuildingIDS = "viewTypeBuildingIds"
        case latitude, longitude, address
        case videoID = "videoId"
        case phoneNumber
    }
}

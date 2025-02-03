//
//  FilterServerModel.swift
//  Master
//
//  Created by Sina khanjani on 3/12/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import Foundation


struct FilterServerResult: Codable {
    let categories: [Category]?
    var features: [Feature]?
    var conditions: [Condition]?
    let provinces: [Province]?
    let priceMin, priceMax: Int?
}

// MARK: - Category
struct Category: Codable, Hashable {
    let title: String?
    let isDelete, isFreeAddEstate: Bool?
    let addEstatePrice: Int?
    let isFreePhoneEstate: Bool?
    let phoneEstatePrice: Int?
//    let estates, estateTypes: JSONNull?
    let id, createDate, modifiedDate: String
}

// MARK: - Condition
struct Condition: Codable, Hashable {
    let id: String
    let title: String
    let type: Int
    let isDelete: Bool?
//    let conditionEstates: JSONNull?
    let createDate, modifiedDate: String?
    var isCheck: Bool? = false // khodam ijad kardam
}

// MARK: - Feature
struct Feature: Codable, Hashable {
    let title: String
    let isDelete: Bool?
//    let featuresEstates: JSONNull?
    let id: String
    let createDate, modifiedDate: String?
    var isCheck : Bool? = false  // khodam ijad kardam
}

// MARK: - Province
struct Province: Codable {
    let id, country: Int?
    let name: String?
    let latitude, longitude: Double?
    let modifiedDate: String?
    let isActive, isDelete: Bool?
//    let estate, accesss, provinceAccessUser, cityAccessUser: JSONNull?
    var isSelected: Bool? = false
}

// MARK: - CityElement
struct City: Codable, Hashable {
    let id, province: Int?
    let name: String?
    let latitude, longitude: Double?
    let isActive, isDelete: Bool?
    let modifiedDate: String?
//    let estate, cityAccessUser: JSONNull?
    var isSelected: Bool? = false

}

// MARK: - EstateTypeModelElement
struct EstateTypeModelElement: Codable, Hashable {
    let estateUseTypeID, title: String?
    let isDelete: Bool?
//    let useType, estates: JSONNull?
    let id, createDate, modifiedDate: String?

    enum CodingKeys: String, CodingKey {
        case estateUseTypeID = "estateUseTypeId"
        case title, isDelete, id, createDate, modifiedDate
//        case estates, useType
    }
}

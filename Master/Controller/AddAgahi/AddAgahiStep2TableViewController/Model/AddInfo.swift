//
//  AddInfo.swift
//  Master
//
//  Created by Sina khanjani on 4/27/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import Foundation
//
// MARK: - AddAgahiModelBody
struct AddInfo: Codable {
    
    let provinces: [Province]?
    let cities: [City]?
    
    var conditions: [Condition]?
    var features: [Feature]?
    var buildingPositions, buildingViewTypes: [Building]?
    
    let estateTypes, buildingDocs: [BuildingDoc]?
    let buildingStructureTypes: [BuildingDoc]?

//    enum CodingKeys: String, CodingKey {
//        case conditions,provinces,estateTypes, buildingDocs, buildingPositions, buildingViewTypes,buildingStructureTypes, features
//    }
}

// MARK: - BuildingDoc
struct BuildingDoc: Codable, Hashable {
    let title: String?
    let isDelete: Bool?
//    let estates: JSONNull?
    let id: String?
        
//    let createDate, modifiedDate: String?
//    let estateUseTypeID: String?
//    let useType: JSONNull?
    let featuresEstates: [Feature]?
    
    enum CodingKeys: String, CodingKey {
        case title, isDelete, id
//        case  createDate, modifiedDate
//        case estateUseTypeID = "estateUseTypeId"
//        case estates
//        case useType
        case featuresEstates
    }
}

// MARK: - Building
struct Building: Codable, Hashable {
    let title: String?
    let type: Int?
    let isDelete: Bool?
//    let buildingPositionEstate: JSONNull?
    let id: String
//    let createDate, modifiedDate: String?
//    let viewTypeBuildingEstate: JSONNull?
    var isCheck : Bool? = false  // khodam ijad kardam
}

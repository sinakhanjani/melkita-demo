//
//  BannerModel.swift
//  Master
//
//  Created by Sina khanjani on 3/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import Foundation


// MARK: - RegisterRe
struct BannerModel: Codable, Hashable {
    let title: String
    let registerReDescription: String?
    let isLink: Bool
    let key: Int
    let sort: Int?
    let isContent: Bool
    let estates: [Estate]

    enum CodingKeys: String, CodingKey {
        case title
        case registerReDescription = "description"
        case isLink, key, sort, isContent, estates
    }
}

// MARK: - Estate
struct Estate: Codable, Hashable {
    let id, province, city: String?
    let type: Int?
    let userID, title, use, estateType: String?
    let metr: Int?
    let countRoom: Int?
    let address, img: String?
    let priceBuy, priceRent, priceMortgage: Int?
    let isMortgage, isAgreementPriceBuy, isAgreementPriceRent, isAgreementPriceMortgage: Bool?
    let user: String?
    let photoURL: String?
    let modifiedDate: String?
    let pictures: [Picture]?
    let key: Int?
    let isSold: Bool?
    let visitCount: Int?
    let ownerName, ladderExpireDate, vipExpireDate, dateUpdated: String?
    let videoURL: String?

    enum CodingKeys: String, CodingKey {
        case id, province, city, type
        case userID = "userId"
        case title, use, estateType, metr, countRoom, address, img, priceBuy, priceRent, priceMortgage, isMortgage, isAgreementPriceBuy, isAgreementPriceRent, isAgreementPriceMortgage, user
        case photoURL = "photoUrl"
        case modifiedDate, pictures, key, isSold, visitCount, ownerName, ladderExpireDate, vipExpireDate, dateUpdated
        case videoURL = "videoUrl"
    }
}

// MARK: - Picture
struct Picture: Codable, Hashable {
    let estateID: String?
    let picURL: String?
    let id, createDate, modifiedDate: String?

    enum CodingKeys: String, CodingKey {
        case estateID = "estateId"
        case picURL = "picUrl"
        case id, createDate, modifiedDate
    }
}

typealias BannerModels = [BannerModel]

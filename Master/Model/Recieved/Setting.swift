//
//  Setting.swift
//  Master
//
//  Created by Sina khanjani on 5/12/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import Foundation


// MARK: - RCSetting
struct RCSetting: Codable {
    let id, createDate, modifiedDate, aboutUs: String?
    let phone, phoneNumber, address, email: String?
    let rules, userRules, advisorRules, marketerRules: String?
    let policy, favoIconURL, logURL, enemad: String?
    let instagramURL, sharing, rcSettingDescription: String?
    let priceLadder, priceVip, estateExpire, ladderExpire: Int?
    let vipExpire, cupenAdvisor, percentageOfMarketerProfits, minPriceProfitMarketer: Int?
    let minClearingMarketer, minIncInventory: Int?
    let isDisabledDiscountCodeAdvisor, isTax: Bool?
    let percentTax: Int?
    let headerImageURL, headerText, headerRegisterPageImageURL, headerLoginPageImageURL: String?
    let headerLoginAdminPageImageURL, headerContactUsPageImageURL, headerAboutUsPageImageURL, headerTermsPageImageURL: String?
    let headerPolicyPageImageURL, headerFAQPageImageURL, headerWorkWithUsPageImageURL, headerFormPageImageURL: String?
    let isDisableRegisterAdvisor, isDisableRegisterMarketer, isDisableRegisterEmployee: Bool?
    let minimumAndroidInstall, maximumAndroidInstall, currentAndroidInstall, minimumIosInstall: String?
    let maximumIosInstall, currentIosInstall, registerMarketerPackageFreeID: String?

    enum CodingKeys: String, CodingKey {
        case id, createDate, modifiedDate, aboutUs, phone, phoneNumber, address, email, rules, userRules, advisorRules, marketerRules, policy
        case favoIconURL = "favoIconUrl"
        case logURL = "logUrl"
        case enemad
        case instagramURL = "instagramUrl"
        case sharing
        case rcSettingDescription = "description"
        case priceLadder, priceVip, estateExpire, ladderExpire, vipExpire, cupenAdvisor, percentageOfMarketerProfits, minPriceProfitMarketer, minClearingMarketer, minIncInventory, isDisabledDiscountCodeAdvisor, isTax, percentTax
        case headerImageURL = "headerImageUrl"
        case headerText
        case headerRegisterPageImageURL = "headerRegisterPageImageUrl"
        case headerLoginPageImageURL = "headerLoginPageImageUrl"
        case headerLoginAdminPageImageURL = "headerLoginAdminPageImageUrl"
        case headerContactUsPageImageURL = "headerContactUsPageImageUrl"
        case headerAboutUsPageImageURL = "headerAboutUsPageImageUrl"
        case headerTermsPageImageURL = "headerTermsPageImageUrl"
        case headerPolicyPageImageURL = "headerPolicyPageImageUrl"
        case headerFAQPageImageURL = "headerFaqPageImageUrl"
        case headerWorkWithUsPageImageURL = "headerWorkWithUsPageImageUrl"
        case headerFormPageImageURL = "headerFormPageImageUrl"
        case isDisableRegisterAdvisor, isDisableRegisterMarketer, isDisableRegisterEmployee, minimumAndroidInstall, maximumAndroidInstall, currentAndroidInstall, minimumIosInstall, maximumIosInstall, currentIosInstall
        case registerMarketerPackageFreeID = "registerMarketerPackageFreeId"
    }
}

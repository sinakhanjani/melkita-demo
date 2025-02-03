//
//  Generic.swift
//  Master
//
//  Created by Sina khanjani on 4/25/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//
import Foundation

// MARK: - RCSendCommentModel
struct Generic: Codable {
    let isSuccess: Bool?
    let msg: String?
    let code: Int?
}

// MARK: - RCSendCommentModel
struct GenericOrginal<T: Codable>: Codable {
    let isSuccess: Bool?
    let msg: String?
    let code: Int?
    let data: T?
}


struct Empty: Codable { }

//
//  SectionModel.swift
//  Master
//
//  Created by Sina khanjani on 3/12/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import Foundation


struct SelectionModel: Hashable {
    var id: String
    var title: String
    let section: Section
    
    func okSelf() -> SelectionModel? {
        if id != "\(SHIT_NUMBER)", !id.isEmpty {
            return self
        } else {
            return nil
        }
    }
}

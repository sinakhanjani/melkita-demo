//
//  Filter.swift
//  Master
//
//  Created by Sina khanjani on 3/12/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import Foundation

struct Filter {
    var estateBaseType: SelectionModel? = SelectionModel(id: "\(SHIT_NUMBER)", title: "انتخاب کنید", section: .estayeBaseType)
    var province: SelectionModel? = SelectionModel(id: "\(SHIT_NUMBER)", title: "انتخاب کنید", section: .provenance)
    var city: SelectionModel? = SelectionModel(id: "\(SHIT_NUMBER)", title: "انتخاب کنید", section: .city)
    var estateUse: SelectionModel? = SelectionModel(id: "\(SHIT_NUMBER)", title: "انتخاب کنید", section: .estateUse)
    var estateType: SelectionModel? = SelectionModel(id: "\(SHIT_NUMBER)", title: "انتخاب کنید", section: .estateType)
    var room: SelectionModel? = SelectionModel(id: "\(SHIT_NUMBER)", title: "انتخاب کنید", section: .room)
    
    var priceFrom: SelectionModel? = SelectionModel(id: "\(SHIT_NUMBER)", title: "", section: .price)
    var priceTo: SelectionModel? = SelectionModel(id: "\(SHIT_NUMBER)", title: "", section: .price)
    var meterFrom: SelectionModel? = SelectionModel(id: "\(SHIT_NUMBER)", title: "", section: .meter)
    var MeterTo: SelectionModel? = SelectionModel(id: "\(SHIT_NUMBER)", title: "", section: .meter)
    
    var newAge: SelectionModel? = SelectionModel(id: "\(SHIT_NUMBER)", title: "نوساز", section: .newAge)
    // condition
    // feature
    
    private func createFilter() -> Filter {
        let filter = Filter(estateBaseType: self.estateBaseType?.okSelf(), province: self.province?.okSelf(), city: self.city?.okSelf(), estateUse: self.estateUse?.okSelf(), estateType: self.estateType?.okSelf(), room: self.room?.okSelf(), priceFrom: self.priceFrom?.okSelf(), priceTo: self.priceTo?.okSelf(), meterFrom: self.meterFrom?.okSelf(), MeterTo: self.MeterTo?.okSelf(), newAge: self.newAge?.okSelf())
        
        return filter
    }
    
    func convertToDict(features: [String]?, conditions: [String]?) -> [String: String] {
        var queryDict = [String: String]()
        let finalFilter = self.createFilter()
        
        if let i = finalFilter.estateBaseType  {
            queryDict.updateValue(i.id, forKey: "Type")
        }
        if let i = finalFilter.province  {
            queryDict.updateValue(i.id, forKey: "ProvinceId")
        }
        if let i = finalFilter.city  {
            queryDict.updateValue(i.id, forKey: "CityId")
        }
        if let i = finalFilter.estateUse  {
            queryDict.updateValue(i.id, forKey: "EstateUseId")
        }
        if let i = finalFilter.estateType  {
            queryDict.updateValue(i.id, forKey: "EstateTypeId")
        }
        if let i = finalFilter.room  {
            queryDict.updateValue(i.id, forKey: "CountRoom")
        }
        if let i = finalFilter.priceFrom  {
            queryDict.updateValue(i.id, forKey: "MinPrice")
        }
        if let i = finalFilter.priceTo  {
            queryDict.updateValue(i.id, forKey: "MaxPrice")
        }
        if let i = finalFilter.meterFrom  {
            queryDict.updateValue(i.id, forKey: "MinMetr")
        }
        if let i = finalFilter.MeterTo  {
            queryDict.updateValue(i.id, forKey: "MaxMetr")
        }
        if let i = finalFilter.newAge {
            queryDict.updateValue(i.id=="0" ? "false":"true" , forKey: "IsNewAge")
        }
        
        func covertStrArray() {
            
        }
        if let features = features, !features.isEmpty {
            let ids = features.joined(separator: ",")
            queryDict.updateValue(ids, forKey: "FeaturesIds")
        }
        if let conditions = conditions, !conditions.isEmpty {
            let ids = conditions.joined(separator: ",")
            queryDict.updateValue(ids, forKey: "ConditionsIds")
        }
        
        print(queryDict)
        
        return queryDict
    }
}

struct FinalFilter {
    var id: String
    var section: Section
}



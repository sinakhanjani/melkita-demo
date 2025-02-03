//
//  EditProfileTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/10/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class EditProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: InsetTextField!
    @IBOutlet weak var familyTextField: InsetTextField!
    @IBOutlet weak var emailTextFiled: InsetTextField!
    @IBOutlet weak var codeMoarefTextField: InsetTextField!
    @IBOutlet weak var companyNameTextField: InsetTextField!
    @IBOutlet weak var phoneCenterTextField: InsetTextField!
    @IBOutlet weak var ostanLabel: UILabel!
    @IBOutlet weak var shahrLabel: UILabel!

    var cities = [City]()
    var item: RCUserInfo?
    var provinces: [Province] = []
    
    var cityID: Int?
    var prvinceID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .black, name: "")
        fetchUserInfoRequest()
    }
    
    func fetchUserInfoRequest() {
        RestfulAPI<Empty,RCUserInfo>.init(path: "/User/info")
            .with(auth: .user)
            .with(method: .GET)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.item = res
                        self.updateUI()
                        self.fetchProvinces()
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
    }
    
    func uploadReq(params:Parameters) {
        guard let name = nameTextField.text, let secondName = familyTextField.text, let companyName = companyNameTextField.text else {
            
            return
        }
        var parameters: Parameters = ["FirstName":name,
                                      "LastName":secondName,
                                      "CompanyName":companyName]
        params.forEach { param in
            parameters.updateValue(param.value, forKey: param.key)
        }
        let userPath = "/User/edit-profile"
        let advisorPath = "/Advisor/edit-profile"
        var str: String?
        if let role = DataManager.shared.role {
            switch role {
            case .EstateAdvisor:
                str = advisorPath
            default:
                str = userPath
            }
        }
        RestfulAPI<File,GenericOrginal<EMPTYMODEL>>.init(path: str ?? "/User/edit-profile")
            .with(method: .PUT)
            .with(auth: .user)
            .with(body: File(key: "Photo", data: Data()))
            .with(parameters: parameters)
            .sendURLSessionRequest { result in
                if case .success(let res) = result {
                    DispatchQueue.main.async {
                        self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                    }
                }
            }
    }
    
    func fetchProvinces() {
        RestfulAPI<EMPTYMODEL,[Province]>.init(path: "Common/provinces")
            .with(method: .GET)
            .sendURLSessionRequest { result in
                if case .success(let items) = result {
                    self.provinces = items
                    DispatchQueue.main.async {
                        if let index = items.lastIndex(where: { i in
                            return i.id == self.item?.provinceId
                        }) {
                            self.ostanLabel.text = items[index].name
                            self.fetchCity(provId: items[index].id!)
                        }
                    }
                }
            }
    }
    
    func updateUI() {
        self.nameTextField.text = item?.firstName
        self.familyTextField.text = item?.lastName
        self.emailTextFiled.text = item?.email
        self.codeMoarefTextField.text = item?.identifierCode ?? item?.marketerKey
        self.cityID = item?.cityId
        self.prvinceID = item?.provinceId
        self.companyNameTextField.text = item?.companyName
        self.phoneCenterTextField.text = item?.phoneCenter
    }
    
    func fetchCity(provId: Int) {
        self.startIndicatorAnimate()
        RestfulAPI<Empty,[City]>.init(path: "/Common/cities/\(provId)")
            .with(method: .GET)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.cities = res
                        if let index = res.lastIndex(where: { i in
                            i.id == self.item?.cityId
                        }) {
                            self.shahrLabel.text = res[index].name
                        }
                        break
                    case .failure(_):
                        break
                    }
                }
            }
    }
    
    @IBAction func addButtontapped(_ sender: Any) {
        var params = ["Email":emailTextFiled.text!,
        ]
        
        if let code = codeMoarefTextField.text, !code.isEmpty {
            params.updateValue(codeMoarefTextField.text!, forKey: "IdentifierCode")
        }
        if let cityID = cityID {
            params.updateValue("\(cityID)", forKey: "CityId")
        }
        if let prvinceID = prvinceID {
            params.updateValue("\(prvinceID)", forKey: "ProvinceId")
        }
        if let phoneCenter = phoneCenterTextField.text, !phoneCenter.isEmpty {
            params.updateValue(phoneCenter, forKey: "PhoneCenter")
        }
        
        uploadReq(params: params)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 6 {
            // ostan
            let vc = SelectionTableViewController.create()
            let provinces = (self.provinces)
            let input = provinces.map { (i) -> SelectionModel in
                SelectionModel(id: "\(i.id ?? SHIT_NUMBER)", title: i.name ?? "بدون نام", section: .provenance)
            }
            vc.delegate = self
            vc.selectionModels = input
            show(vc, sender: nil)
        }
        if indexPath.section == 7 {
            let vc = SelectionTableViewController.create()
            let input = cities.map { (i) -> SelectionModel in
                SelectionModel(id: "\(i.id ?? SHIT_NUMBER)", title: i.name ?? "بدون نام", section: .city)
            }
            vc.selectionModels = input
            vc.delegate = self
            show(vc, sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            if let userType = DataManager.shared.role {
                if case .Marketer = userType {
                    return 0
                }
            }
        }
        
        if indexPath.section == 4 || indexPath.section == 5 {
            if let role = DataManager.shared.role {
                switch role {
                case .EstateAdvisor: return 58
                default: return 0
                }
            }
        }
        
        return 58
    }
}

extension EditProfileTableViewController: SelectionTableViewControllerDelegate {
    func didselectSection(item: SelectionModel) {
        if let indexPath = tableView.indexPathForSelectedRow {
            if indexPath.section == 6 {
                // ostan
                self.prvinceID = Int(item.id)!
                self.ostanLabel.text = item.title
                self.fetchCity(provId: Int(item.id)!)
                self.shahrLabel.text = "شهر را انتخاب کنید"
            }
            if indexPath.section == 7 {
                // shahrs
                self.cityID = Int(item.id)!
                self.shahrLabel.text = item.title
            }
        }
    }
}

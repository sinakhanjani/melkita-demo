//
//  AddAgahiStep2TableViewController.swift
//  Master
//
//  Created by Sina khanjani on 4/26/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class AddAgahiStep2TableViewController: UITableViewController {
    
    @IBOutlet weak var agahiLabel: UILabel!
    @IBOutlet weak var onvanTextField: InsetTextField!
    @IBOutlet weak var mobileTextField: InsetTextField!
    @IBOutlet weak var metrajTextField: InsetTextField!
    @IBOutlet weak var noeMelkLabel: UILabel!
    @IBOutlet weak var descriptionTextVie: UITextView!
    
    var addAgahi = AddAgahiModelBody()
    var addInfo: AddInfo?
    var isUpdate = false
    var updateEstateID: String?
    var agahiModel: AgahiModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ثبت آگهی"
        descriptionTextVie.font = UIFont.persianFont(size: 17)
        backBarButtonAttribute(color: .black, name: "")
        self.mobileTextField.text = DataManager.shared.userProfile?.data?.phoneNumber
        if isUpdate {
            if let id = updateEstateID {
                fetchUpdateEstate(id: id)
            }
        }
    }
    
    func fetchUpdateEstate(id: String) {
        startIndicatorAnimate()
        RestfulAPI<Empty,AgahiModel>.init(path: "/Estate/\(id)")
            .with(method: .GET)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.agahiModel = res
                        
                        self.onvanTextField.text = res.title
                        self.descriptionTextVie.text = res.estateTypeModelDescription
                        self.agahiLabel.text = res.useTypeEstate?.title
                        self.noeMelkLabel.text = res.useTypeEstate?.estateTypes[0].title
                        self.metrajTextField.text = "\(res.metr)"
                        self.mobileTextField.text = res.phoneNumber
                        
                        self.addAgahi.estateTypeID = res.estateType?.id
                        self.addAgahi.estateUseID = res.estateType?.estateUseTypeID
                        self.addAgahi.metr = res.metr
                        self.addAgahi.type = res.type
                        self.addAgahi.phoneNumber = self.mobileTextField.text
                        self.addAgahi.title = self.onvanTextField.text
                        self.addAgahi.addAgahiModelBodyDescription = self.descriptionTextVie.text!
                        if let estateUseTypeID = res.estateType?.estateUseTypeID, let type = res.type {
                            self.fetchAddInfoUpdate(eststeType: "\(type)", estateUseTypeId: estateUseTypeID)
                        }
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
    }
    
    func fetchAddInfoUpdate(eststeType: String, estateUseTypeId: String) {
        startIndicatorAnimate()
        RestfulAPI<Empty,AddInfo>.init(path: "/Estate/Estate/add-info")
            .with(queries: ["eststeType":eststeType , "estateUseTypeId":estateUseTypeId])
            .with(method: .GET)
            .with(auth: .user)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.addInfo = res
                        
                        break
                    case .failure(_):
                        break
                    }
                }
            }
    }
    
    func fetchAddInfo() {
        startIndicatorAnimate()
        RestfulAPI<Empty,AddInfo>.init(path: "/Estate/Estate/add-info")
            .with(queries: ["eststeType":"\(addAgahi.type ?? 1)" , "estateUseTypeId":addAgahi.estateUseID!])
            .with(method: .GET)
            .with(auth: .user)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.addInfo = res
                        
                        break
                    case .failure(_):
                        break
                    }
                }
            }
    }

    @IBAction func agreeButtonTapped(_ sender: Any) {
        guard mobileTextField.text!.count == 11 else {
            presentCDAlertWarningAlert(message: "شماره موبایل میبایست ۱۱ رقم باشد", completion: {})
            return
        }
        
        guard metrajTextField.text!.count > 0, Int(metrajTextField.text!) != nil else {
            presentCDAlertWarningAlert(message: "لطفا متراژ را وارد کنید", completion: {})
            return
        }
        
        guard onvanTextField.text!.count > 0 else {
            presentCDAlertWarningAlert(message: "لطفا عنوان را وارد کنید", completion: {})
            return
        }
        
        guard descriptionTextVie.text!.count > 14 else {
            presentCDAlertWarningAlert(message: "لطفا توضیحات ملک را کامل وارد کنید", completion: {})
            return
        }
        
        guard addAgahi.type != nil else {
            presentCDAlertWarningAlert(message: "لطفا نوع آگهی را انتخاب کنید", completion: {})
            return
        }
        
        guard addAgahi.estateTypeID != nil else {
            presentCDAlertWarningAlert(message: "لطفا نوع ملک را انتخاب کنید", completion: {})
            return
        }
        
        addAgahi.phoneNumber = mobileTextField.text
        addAgahi.metr = Int(metrajTextField.text!)!
        addAgahi.title = onvanTextField.text
        addAgahi.addAgahiModelBodyDescription = descriptionTextVie.text!
        
        let vc = AddAgahiStep3TableViewController.create()
        vc.addAgahi = addAgahi
        vc.addInfo = addInfo
        
        vc.isUpdate = isUpdate
        vc.agahiModel = agahiModel
        vc.updateEstateID = updateEstateID
        
        show(vc, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // noe agahi
            let items = [SelectionModel(id: "1", title: "خرید و فروش", section: .estayeBaseType), SelectionModel(id: "2", title: "رهن و اجاره", section: .estayeBaseType)]
            let vc = SelectionTableViewController.create()
            vc.delegate = self
            vc.selectionModels = items
            show(vc, sender: nil)
        }
        
        if indexPath.section == 3 {
            // noe melk
            if let addInfo = addInfo {
                let items = addInfo.estateTypes
                let vc = SelectionTableViewController.create()
                vc.delegate = self
                vc.selectionModels = items?.map { SelectionModel(id: $0.id ?? "X", title: $0.title ?? "", section: .estateType) }
                show(vc, sender: nil)
            } else {
                presentCDAlertWarningAlert(message: "لطفا نوع آگهی را انتخاب کنید", completion: {})
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isUpdate {
            if indexPath.section == 0 {
                cell.backgroundColor = .gray
                cell.isUserInteractionEnabled = false
            }
            if indexPath.section == 3 {
                cell.backgroundColor = .gray
                cell.isUserInteractionEnabled = false
            }
        }
    }
}

extension AddAgahiStep2TableViewController: SelectionTableViewControllerDelegate {
    func didselectSection(item: SelectionModel) {
        if let indexPath = tableView.indexPathForSelectedRow {
            if indexPath.section == 0 {
                // noe agahi
                self.agahiLabel.text = item.title
                addAgahi.type = Int(item.id)!
                self.fetchAddInfo()
            }
            
            if indexPath.section == 3 {
                // noe melk
                self.noeMelkLabel.text = item.title
                addAgahi.estateTypeID = item.id
            }
        }
    }
}

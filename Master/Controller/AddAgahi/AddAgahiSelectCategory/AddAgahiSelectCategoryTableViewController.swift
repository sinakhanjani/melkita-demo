//
//  AddAgahiSelectCategoryTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 4/26/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class AddAgahiSelectCategoryTableViewController: UITableViewController {

    @IBOutlet weak var offLineView: UIView!
    @IBOutlet weak var stackLabel1: UILabel!
    @IBOutlet weak var stackLabel2: UILabel!
    @IBOutlet weak var stackLabel3: UILabel!
    @IBOutlet weak var stackLabel4: UILabel!

    @IBOutlet weak var noeMelklabel: UILabel!
    
    var addAgahi = AddAgahiModelBody()
    var items = [Category]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !Authentication.user.isLogin {
            tabBarController?.selectedIndex = 0
        }
        
        if !DataManager.shared.isApproveDocument {
            let headerView = NotApproveView(height: 100)
            headerView.titleLabel.text = "مدارک شما هنوز تایید نشده و قادر به ثبت آگهی جدید نخواهید بود"
            self.tableView.tableHeaderView = headerView
        } else if !DataManager.shared.isAccountApprive {
            let headerView = NotApproveView(height: 100)
            headerView.titleLabel.text = "هویت شما هنوز تایید نشده است"
            self.tableView.tableHeaderView = headerView
        }
        else {
            self.tableView.tableHeaderView = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.offLineView.alpha = 0
        backBarButtonAttribute(color: .black, name: "")
        fetch()
        stackLabel1.text = "دسته بندی آگهی را جهت رویت هزینه ثبت آگهی انتخاب نمایید"

    }
    
    func updateUI(price: Int, offPrice: Int?) {
        if let offPrice = offPrice {
            stackLabel2.text = "مبلغ: \(price.seperateByCama)"
            stackLabel3.text = "مبلغ با تخفیف: \(offPrice.seperateByCama)"
            stackLabel4.text = "را پرداخت کنید"
            self.offLineView.alpha = 1
        } else {
            stackLabel2.text = "مبلغ: \(price.seperateByCama)"
            stackLabel3.text = "را پرداخت کنید"
            stackLabel4.text = ""
            self.offLineView.alpha = 0
        }
    }
    
    func fetch() {
        startIndicatorAnimate()
        RestfulAPI<Empty,[Category]>.init(path: "/Common/categories/estate")
            .with(method: .GET)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.items = res
                    case .failure(_):
                        break
                    }
                }
            }
    }
    
    func fetchAddPrice(id: String) {
        startIndicatorAnimate()
        RestfulAPI<Empty,AddAgahiStatus>.init(path: "/Estate/price-add/\(id)")
            .with(method: .GET)
            .with(auth: .user)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        var price: Int = 0
                        var offPrice: Int?
                        if let price1 = res.addEstatePrice {
                            price = price1
                        }
                        if let price1 = res.discountPrice {
                            offPrice = price1
                        }
                        
                        self.updateUI(price: price, offPrice: offPrice)
                    case .failure(_):
                        break
                    }
                }
            }
    }

    @IBAction func agreeButtonTapped(_ sender: Any) {
        if !DataManager.shared.isApproveDocument {
            presentCDAlertWarningAlert(message: "لطفا مدارک خود را از قسمت پروفایل تکمیل نمایید", completion: {})
            return
        }
        if !DataManager.shared.isAccountApprive {
            presentCDAlertWarningAlert(message: "لطفا تا تایید شدن هویت خود منتظر بمانید", completion: {})
            return
        }
        guard addAgahi.estateUseID != nil else {
            presentCDAlertWarningAlert(message: "لطفا کاربری ملک را انتخاب کنید", completion: {})
            return
        }
        
        let vc = AddAgahiStep2TableViewController.create()
        vc.addAgahi = addAgahi
        
        show(vc, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if !DataManager.shared.isApproveDocument {
                presentCDAlertWarningAlert(message: "لطفا مدارک خود را از قسمت پروفایل تکمیل نمایید", completion: {})
                return
            }
            if !DataManager.shared.isAccountApprive {
                presentCDAlertWarningAlert(message: "لطفا تا تایید شدن هویت خود منتظر بمانید", completion: {})
                return
            }
            let vc = SelectionTableViewController.create()
            vc.delegate = self

            let converted = items.map { SelectionModel(id: $0.id, title: $0.title ?? "", section: .estateUse) }
            vc.selectionModels = converted
            
            show(vc, sender: nil)
        }
    }
}

extension AddAgahiSelectCategoryTableViewController: SelectionTableViewControllerDelegate {
    func didselectSection(item: SelectionModel) {
        self.addAgahi = AddAgahiModelBody()
        self.noeMelklabel.text = item.title
        self.addAgahi.estateUseID = item.id
        fetchAddPrice(id: item.id)
    }
}

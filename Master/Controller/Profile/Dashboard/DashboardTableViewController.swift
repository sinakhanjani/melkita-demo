//
//  DashboardTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/10/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class DashboardTableViewController: UITableViewController {
    
    @IBOutlet weak var pardakhtEmroLabel: UILabel!
    @IBOutlet weak var walletPriceLabel: UILabel!
    @IBOutlet weak var mojodiPorsantLabel: UILabel!
    
    var porsantPrice: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "داشبورد"

        backBarButtonAttribute(color: .black, name: "")
        
        if DataManager.shared.role == .Marketer {
            if !DataManager.shared.isApproveDocument {
                let headerView = NotApproveView(height: 100)
                headerView.titleLabel.text = "مدارک شما هنوز تایید نشده "
                self.tableView.tableHeaderView = headerView
                return
            } else if !DataManager.shared.isAccountApprive {
                let headerView = NotApproveView(height: 100)
                headerView.titleLabel.text = "هویت شما هنوز تایید نشده است"
                self.tableView.tableHeaderView = headerView
                return
            } else if !DataManager.shared.hasMarketerPackage {
                let headerView = NotApproveView(height: 100)
                headerView.titleLabel.text = "بازاریاب عزیز لطفا جهت کسب درامد یک اشتراک بازاریابی خرید کنید"
                headerView.bgView.layer.borderColor = UIColor.blue.cgColor
                headerView.titleLabel.textColor = .blue
                self.tableView.tableHeaderView = headerView
                return
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUserInfoRequest()
        fetchPrice()
    }
    
    func fetchUserInfoRequest() {
        RestfulAPI<Empty,RCUserInfo>.init(path: "/User/info")
        .with(auth: .user)
        .with(method: .GET)
        .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let res):
                    self.porsantPrice = res.credit
                    self.walletPriceLabel.text = "\((res.inventory ?? 0).seperateByCama)" + " " + "تومان"
                    self.mojodiPorsantLabel.text = res.credit?.seperateByCama ?? ""
                    DataManager.shared.userInfo = res
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }

    func fetchPrice() {
        struct CHECK: Codable { let depositPayToday: Int? }
        RestfulAPI<Empty,CHECK>.init(path: "/Marketer/credit-inventory")
        .with(auth: .user)
        .with(method: .GET)
        .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let res):
                    self.pardakhtEmroLabel.text = res.depositPayToday?.seperateByCama ?? ""
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            // list tarakoneshha
            // open safe pardakhthaye man
            let vc = PardakhtiManTableViewController.create()
            vc.queries = ["IsWallet":String(describing: true)]
            show(vc, sender: nil)
        }
        if indexPath.section == 2 {
            if indexPath.item == 1 {
                // kharidhaye Moarefan
                let vc = MoarefanManTableViewController.create()
                show(vc, sender: nil)
            }
            if !DataManager.shared.isApproveDocument {
                self.presentCDAlertWarningAlert(message: "مدارک شما هنوز تایید نشده است", completion: {})
                return
            } else if !DataManager.shared.isAccountApprive {
                self.presentCDAlertWarningAlert(message: "هویت شما هنوز تایید نشده است", completion: {})
                return
            } else if !DataManager.shared.hasMarketerPackage {
                self.presentCDAlertWarningAlert(message: "بازاریاب عزیز لطفا جهت کسب درامد یک اشتراک بازاریابی خرید کنید", completion: {})
                return
            } else if DataManager.shared.hasMarketerPackage == false {
                self.presentCDAlertWarningAlert(message: "اکانت بازاریابی شما منقضی شده است و امکان تسویه حساب وجود ندارد", completion: {})
                return
            }
            if indexPath.item == 2 {
                // tasvie hesab
                let price = Int(self.porsantPrice ?? 0)
                guard price >= 300000 else {
                    presentCDAlertWarningAlert(message: "موجودی شما از سیصد هزار تومان کمتر است", completion: {})
                    return
                }
                let vc = UINavigationController.create(withId: "TasviehTableViewControllerNav")
                show(vc, sender: nil)
                
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if DataManager.shared.role == .Marketer {
            return 3
        }
        return 2
    }
    
    @IBAction func addButtonTapped() {
        let vc = UINavigationController.create(withId: "CreditUpTableViewControllerNav")
        show(vc, sender: nil)
    }
}

//نوع واریز
public enum DepositTypeEnum: Int, CaseIterable
        {
            case Wallet = 1
            case Card = 2
    
    func name() -> String {
        switch self {
        case .Wallet:
            return "واریز به کیف پول"
        case .Card:
            return "واریز به حساب بانکی"
        }
    }
    
    var value: String {
        switch self {
        case .Wallet:
            return "1"
        case .Card:
            return "2"
        }
    }
}
// وضعیت واریز
public enum DepositStatusEnum: Int,CaseIterable
        {
            case Pending = 0
            case Approve = 1
            case Pay = 2
            case Failed = 3
    
    func name() -> String {
        switch self {
        case .Pending:
            return "در حال بررسی"
        case .Approve: return  "تایید شده"
        case .Pay:return    "پرداخت شده"
        case .Failed:return  "تایید نشده"
        }
    }
        }

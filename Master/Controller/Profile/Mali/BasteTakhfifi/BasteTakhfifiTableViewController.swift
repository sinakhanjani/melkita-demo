//
//  BasteTakhfifiTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class BasteTakhfifiTableViewController: UITableViewController {
    
    var items = [DiscountPackage]()
    var userItems = [UserDiscountPackage]()
    
    var info: RCUserInfo?
    
    enum Section: Hashable {
        case main
        case user
    }
    
    enum Item: Hashable {
        case user(UserDiscountPackage)
        case main(DiscountPackage)
    }
    
    private var tableViewDataSource: UITableViewDiffableDataSource<Section,Item>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !DataManager.shared.isApproveDocument {
            let headerView = NotApproveView(height: 100)
            headerView.titleLabel.text = "مدارک شما هنوز تایید نشده و قادر به خرید بسته تخفیفی نخواهید بود"
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
        title = "بسته تخفیقی"
        self.info = DataManager.shared.userInfo
        backBarButtonAttribute(color: .black, name: "")
        perform()
        print(Authentication.user.isLogin)
        fetchUserInfoRequest()
    }
    
    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section,Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
        snapshot.appendSections([.main, .user])
        
        let mainItems = items.map { Item.main($0) }
        snapshot.appendItems(mainItems, toSection: .main)
        
        let userItems = userItems.map { Item.user($0) }
        snapshot.appendItems(userItems, toSection: .user)
        
        return snapshot
    }
    
    private func perform() {
        snapshot = createSnapshot()
        tableViewDataSource = UITableViewDiffableDataSource<Section,Item>(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            switch item {
            case .user(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: "payedCell") as! BasteTakhfifiTableViewCell
                cell.delegate = self
                // user package
                cell.label1.text = model.package?.title
                cell.label2.text = "\(model.package?.days ?? 0) روز"
                cell.label3.text = "\(model.package?.estateCount ?? 0)"
                cell.label4.text = (model.package?.price?.seperateByCama ?? "") +  " " + "تومان"
                if let role = DataManager.shared.role {
                    switch role {
                    case .Admin,.SuperAdmin:
                        cell.offLineView.alpha = 0
                    case .User:
                        if self.info?.identifierCode != nil {
                            cell.label5.text = (model.package?.discountMarketerIntroPrice?.seperateByCama ?? "") +  " " + "تومان"//
                        } else {
                            cell.label5.text = (model.package?.discountCustomerPrice?.seperateByCama ?? "") +  " " + "تومان"//
                        }
                    case .Marketer:
                        cell.label5.text = (model.package?.discountMarketerIntroPrice?.seperateByCama ?? "") +  " " + "تومان"//
                    case .EstateAdvisor:
                        if self.info?.identifierCode != nil {
                            cell.label5.text = (model.package?.discountMarketerIntroPrice?.seperateByCama ?? "") +  " " + "تومان"//
                        } else {
                            cell.label5.text = (model.package?.discountAdvisorPrice?.seperateByCama ?? "") +  " " + "تومان"//
                        }
                    default: break
                    }
                }
                cell.label6.text = (model.package?.estatePrice?.seperateByCama ?? "") +  " " + "تومان"
                
                cell.iconImageView1.image = UIImage(systemName: (model.package?.isAddEstate ?? false) ? "checkmark":"xmark")
                cell.iconImageView2.image = UIImage(systemName: (model.package?.isVipEstate ?? false) ? "checkmark":"xmark")
                cell.iconImageView3.image = UIImage(systemName: (model.package?.isLadderEstate ?? false) ? "checkmark":"xmark")
                cell.iconImageView4.image = UIImage(systemName: (model.package?.isExEstate ?? false) ? "checkmark":"xmark")
                cell.iconImageView5.image = UIImage(systemName: (model.package?.isInformationPhoneEstate ?? false) ? "checkmark":"xmark")
                cell.iconImageView1.tintColor = (model.package?.isAddEstate ?? false) ? UIColor.green:UIColor.red
                cell.iconImageView2.tintColor = (model.package?.isVipEstate ?? false) ? UIColor.green:UIColor.red
                cell.iconImageView3.tintColor = (model.package?.isLadderEstate ?? false) ? UIColor.green:UIColor.red
                cell.iconImageView4.tintColor = (model.package?.isExEstate ?? false) ? UIColor.green:UIColor.red
                cell.iconImageView5.tintColor = (model.package?.isInformationPhoneEstate ?? false) ? UIColor.green:UIColor.red
                
                cell.label7.text = "" + "\(model.package?.estateCount ?? 0)"
                cell.label8.text = "" + "\(model.estateCount ?? 0)"
                cell.label9.text = "" + "\(model.expireDate?.persianDateWithFormat("YYYY/MM/dd") ?? "")"
                
                return cell
            case .main(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: "payCell") as! BasteTakhfifiTableViewCell
                cell.delegate = self
                // package
                cell.label1.text = model.title
                cell.label2.text = "\(model.days ?? 0) روز"
                cell.label3.text = "\(model.estateCount ?? 0)"
                cell.label4.text = (model.price?.seperateByCama ?? "") +  " " + "تومان"
                if let role = DataManager.shared.role {
                    switch role {
                    case .Admin,.SuperAdmin:
                        cell.offLineView.alpha = 0
                    case .User:
                        if self.info?.identifierCode != nil {
                            cell.label5.text = (model.discountMarketerIntroPrice?.seperateByCama ?? "") +  " " + "تومان"//
                        } else {
                            cell.label5.text = (model.discountCustomerPrice?.seperateByCama ?? "") +  " " + "تومان"//
                        }
                    case .Marketer:
                        cell.offLineView.alpha = 0
                        cell.label5.text = (model.price?.seperateByCama ?? "") +  " " + "تومان"
                        //                        cell.label5.text = (model.discountMarketerIntroPrice?.seperateByCama ?? "") +  " " + "تومان"//
                    case .EstateAdvisor:
                        if self.info?.identifierCode != nil {
                            cell.label5.text = (model.discountMarketerIntroPrice?.seperateByCama ?? "") +  " " + "تومان"//
                        } else {
                            cell.label5.text = (model.discountAdvisorPrice?.seperateByCama ?? "") +  " " + "تومان"//
                        }
                    default: break
                    }
                }
                cell.label6.text = (model.estatePrice?.seperateByCama ?? "") +  " " + "تومان"
                
                cell.iconImageView1.image = UIImage(systemName: (model.isAddEstate ?? false) ? "checkmark":"xmark")
                cell.iconImageView2.image = UIImage(systemName: (model.isVipEstate ?? false) ? "checkmark":"xmark")
                cell.iconImageView3.image = UIImage(systemName: (model.isLadderEstate ?? false) ? "checkmark":"xmark")
                cell.iconImageView4.image = UIImage(systemName: (model.isExEstate ?? false) ? "checkmark":"xmark")
                cell.iconImageView5.image = UIImage(systemName: (model.isInformationPhoneEstate ?? false) ? "checkmark":"xmark")
                cell.iconImageView1.tintColor = (model.isAddEstate ?? false) ? UIColor.green:UIColor.red
                cell.iconImageView2.tintColor = (model.isVipEstate ?? false) ? UIColor.green:UIColor.red
                cell.iconImageView3.tintColor = (model.isLadderEstate ?? false) ? UIColor.green:UIColor.red
                cell.iconImageView4.tintColor = (model.isExEstate ?? false) ? UIColor.green:UIColor.red
                cell.iconImageView5.tintColor = (model.isInformationPhoneEstate ?? false) ? UIColor.green:UIColor.red
                return cell
            }
        })
        
    }
    
    func reload() {
        snapshot = createSnapshot()
        tableViewDataSource.apply(snapshot)
    }
    
    func fetchAllPackage() {
        RestfulAPI<EMPTYMODEL,[DiscountPackage]>.init(path: "/DiscountPackage")
            .with(auth: .user)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.items = res
//                        self.items = self.items.filter { !self.userItems.map(\.package!.id!).contains($0.id!) }
                        self.items = self.items.filter { item in
                            if let index = self.userItems.lastIndex(where: { usr in
                                return usr.package!.id == item.id
                            }) {
                                let user = self.userItems[index]
                                if (user.estateCount == 0) || (user.estateCount == nil) {
                                    return true
                                }
                                if let date = user.expireDate?.toDate(), Date() >= date.addingTimeInterval(-(60*60*24)) {
                                    return true
                                }

                                return false
                            } else {
                                return true
                            }
                        }
                        
                        self.reload()
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
    }
    
    func fetchUserPackage() {
        RestfulAPI<EMPTYMODEL,[UserDiscountPackage]>.init(path: "/DiscountPackage/user-buy")
            .with(auth: .user)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.userItems = res
//                        self.items = self.items.filter { !res.map(\.package!.id!).contains($0.id!) }
                        self.fetchAllPackage()
                        self.reload()
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
    }
    
    func payFreeReq(id: String) {
        RestfulAPI<EMPTYMODEL,GenericOrginal<EMPTYMODEL>>.init(path: "/DiscountPackage/buy/\(id)")
            .with(auth: .user)
            .with(method: .GET)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        if res.isSuccess ?? false {
                            self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                        }
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func openPaymentVC(price: Int?, offPrice: Int?, packageId: String) {
        let nav = UINavigationController.create(withId: "UINavigationControllerPayment") as! UINavigationController
        let vc = nav.viewControllers.first as! PaymentTableViewController
        vc.type = 6
        vc.rcPayment = RCPaymentModel(price: price, discountPrice: offPrice)
        vc.packageId = packageId
        /*
         نوع پرداخت Type
         public enum OrderTypeEnum
         {
         InfoEstatatePhone = 1, // phone
         LadderEstate = 2, // nardeban
         VipEstate = 3, // vije
         AddEstate = 4, // sakht agahi jadid
         //تمدید آگهی
         ExEstate = 5, // tamdid
         DiscountPackage = 6, kharid baste takhfifi
         IncInventoryWallet = 7
         }
         */
        present(nav, animated: true, completion: nil)
    }
}

extension BasteTakhfifiTableViewController: BasteTakhfifiTableViewCellDelegate {
    func tarakoneshButtonTapped(cell: BasteTakhfifiTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let vc = PardakhtiManTableViewController.create()
            let id = userItems[indexPath.item].id!
            vc.queries = ["DiscountPackageUserId":id]
            
            show(vc, sender: nil)
        }
    }
    
    func switchValueChanged(_ sender: UISwitch, cell: BasteTakhfifiTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            struct Send: Codable {
                let id: String
                let isActive: Bool
            }
            let item = userItems[indexPath.item]
            RestfulAPI<Send,GenericOrginal<EMPTYMODEL>>.init(path: "/DiscountPackage/change-status")
                .with(auth: .user)
                .with(method: .PATCH)
                .with(body: Send(id: item.id!, isActive: sender.isOn))
                .sendURLSessionRequest { (result) in
                    DispatchQueue.main.async {
                        self.stopIndicatorAnimate()
                        switch result {
                        case .success(let res):
                            if res.isSuccess ?? false {
                                self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                            }
                            break
                        case .failure(let err):
                            print(err)
                        }
                    }
                }
        }
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
                        DataManager.shared.userInfo = res
                        self.info = res
//                        self.fetchAllPackage()
                        self.fetchUserPackage()
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
    }
    
    func payButtonTapped(cell: BasteTakhfifiTableViewCell) {
        if !DataManager.shared.isApproveDocument {
            presentCDAlertWarningAlert(message: "لطفا مدارک خود را از قسمت پروفایل تکمیل نمایید", completion: {})
            return
        }
        if !DataManager.shared.isAccountApprive {
            presentCDAlertWarningAlert(message: "لطفا تا تایید شدن هویت خود منتظر بمانید", completion: {})
            return
        }
        if let indexPath = tableView.indexPath(for: cell) {
            let item = items[indexPath.item]
            if item.isFree == true {
                //send req
                if let id = item.id {
                    self.payFreeReq(id: id)
                }
                return
            }
            // if not free
            if self.info == nil {
                presentCDAlertWarningAlert(message: "لطفا مجددا تلاش کنید", completion: {})
                return
            }
            var offPrice: Int? = 0
            if let role = DataManager.shared.role {
                switch role {
                case .Admin, .SuperAdmin:
                    offPrice = nil
                case .User:
                    if self.info?.identifierCode != nil {
                        offPrice = item.discountMarketerIntroPrice ?? 0
                    } else {
                        offPrice = item.discountCustomerPrice ?? 0
                    }
                case .Marketer:
                    offPrice = nil//item.discountMarketerIntroPrice ?? 0
                case .EstateAdvisor:
                    if self.info?.identifierCode != nil {
                        offPrice = item.discountMarketerIntroPrice ?? 0
                    } else {
                        offPrice = item.discountAdvisorPrice ?? 0
                    }
                default: break
                }
            } else {
                return
            }
            
            if (offPrice ?? 0) > 0 {
                // send req
                // open paymentvc
                // **
                if let price = item.price {
                    self.openPaymentVC(price: price, offPrice: offPrice, packageId: item.id!)
                }
            } else {
                if let price = item.price {
                    self.openPaymentVC(price: price, offPrice: nil, packageId: item.id!)
                }
            }
        }
    }
}

// MARK: - Element
struct DiscountPackage: Codable, Hashable {
    let id, createDate, modifiedDate, title: String?
    let isActive, isDelete: Bool?
    let estateCount, estatePrice: Int?
    let estateIsFree: Bool?
    let days, price, discountAdvisorPrice, discountCustomerPrice: Int?
    let discountMarketerIntroPrice: Int?
    let isFree, isInformationPhoneEstate, isLadderEstate, isVipEstate: Bool?
    let isAddEstate, isExEstate: Bool?
}


// MARK: - Element
struct UserDiscountPackage: Codable, Hashable {
    let id, createDate, modifiedDate, userId: String?
    let packageId: String?
    let isActive, isLimitEstateCount: Bool?
    let estateCount: Int? //
    let expireDate: String? //
    let package:DiscountPackage?
}

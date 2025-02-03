//
//  AgahiManTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/10/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class AgahiManTableViewController: UITableViewController {
    
    var items = [RCAgahiManModelElement]()
    
    var query: [String:String]?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !DataManager.shared.isApproveDocument {
            let headerView = NotApproveView(height: 100)
            headerView.titleLabel.text = "مدارک شما هنوز تایید نشده و قادر به ثبت آگهی نخواهید بود"
            self.tableView.tableHeaderView = headerView
        }
        else if !DataManager.shared.isAccountApprive {
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
        title = "آگهی‌های من"
        backBarButtonAttribute(color: .black, name: "")
        if let query = query {
            fetch(query: query)
        } else {
            fetch(query: [:])
        }
    }
    
    func fetch(query: [String:String]) {
        var all = [String: String]()
        all = query
        all.updateValue("1", forKey: "Page")
        all.updateValue("1000", forKey: "PageSize")
        print(all)
        RestfulAPI<Empty,[RCAgahiManModelElement]>.init(path: "/User/estates")
        .with(auth: .user)
        .with(method: .GET)
        .with(queries: all)
        .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                self.stopIndicatorAnimate()
                switch result {
                case .success(let res):
                    self.items = res
                    self.tableView.reloadData()
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AgahiManTableViewCell
        let item = items[indexPath.item]
        cell.delegate = self
        
        if let status = item.status, let some = EstateStatusEnum(rawValue: status) {
            cell.vaziyatAgahiLabel.text = some.title()
            if case .Approve = some {
                cell.agahiView.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.3978117858, blue: 0.1953154064, alpha: 1)
            } else {
                cell.agahiView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            }
        }
        cell.nameMelkLabel.text = item.title
        cell.agahiImageView.loadImageUsingCache(withUrl: item.img ?? "")
        cell.checkMark.isChecked = (item.isSold ?? false)
        if item.isAgreementPriceBuy ?? false {
            cell.kharidYaForoshTagButton.setTitle("خرید", for: .normal)
        } else {
            cell.kharidYaForoshTagButton.setTitle("اجاره", for: .normal)
        }
        cell.categoryTagButton.setTitle(item.category ?? "", for: .normal)
        cell.subCategoryTagButton.setTitle(item.childCategory ?? "", for: .normal)
        if let strDate = item.expireDate?.persianDateWithFormat("YYY/MM/dd") {
            cell.dateTagButton.setTitle("انقضاء: \(strDate)", for: .normal)
        } else {
            cell.dateTagButton.setTitle("انقضاء: هیچ‌وقت", for: .normal)
        }
        if item.isSold ?? false {
            cell.forokhteShodeTagButton.setTitle("ملک فروخته شده", for: .normal)
        } else {
            cell.forokhteShodeTagButton.setTitle("ملک به فروش نرسیده", for: .normal)
        }
        cell.addressLabel.text = item.address
        
        //conditions:
        // 1.nardeban
        let fiveDatFromNow = Date().addingTimeInterval(60*60*24*5)
        if (item.status == 2 && ((item.isFreeAdd ?? false) || (item.expireDate != nil && (item.expireDate?.toDate() ?? Date()) > fiveDatFromNow)) && (!(item.isLadder ?? false) || ((item.isLadder ?? false) && (item.ladderExpireDate?.toDate() ?? Date()) < Date()))) {
            cell.nardebanButton.alpha = 1
        } else {
            cell.nardebanButton.alpha = 0
        }
        // vije
        if (item.status == 2 && ((item.isFreeAdd ?? false) || (item.expireDate != nil && (item.expireDate?.toDate() ?? Date()) > fiveDatFromNow)) && (!(item.isVip ?? false) || ((item.isVip ?? false) && (item.vipExpireDate?.toDate() ?? Date()) < Date()))) {
            cell.vijeButton.alpha = 1
        } else {
            cell.vijeButton.alpha = 0
        }
        // tamdid
        if (item.status != 4 && (!(item.isFreeAdd ?? false) && item.expireDate != nil && (item.expireDate?.toDate() ?? Date()) < fiveDatFromNow)) {
            cell.payButton.setTitle("تمدید", for: .normal)
            cell.alpha = 1
        } else {
            cell.payButton.alpha = 0
        }
        
        if item.status == 4 {
            cell.payButton.setTitle("پرداخت", for: .normal)
            cell.payButton.alpha = 1
            cell.checkMark.alpha = 0
        }
        if item.status != 4 {
            cell.editButton.alpha = 1
        } else {
            cell.editButton.alpha = 0
        }
        
        cell.checkMark.valueChanged = { state in
            // MARK: - RCAgahiManModel
            struct Send: Codable {
                let estateID: String
                let isSold: Bool

                enum CodingKeys: String, CodingKey {
                    case estateID = "estateId"
                    case isSold
                }
            }
            RestfulAPI<Send,GenericOrginal<EMPTYMODEL>>.init(path: "/Estate/sold")
            .with(auth: .user)
            .with(method: .PATCH)
                .with(body: Send(estateID: item.id!, isSold: cell.checkMark.isChecked))
                .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.fetch(query: [:])
                        self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
        }
        
    if !DataManager.shared.isApproveDocument || DataManager.shared.isAccountApprive {
            cell.hideAllButton()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // show agahi vc
        let vc = AgahiTableViewController.create()
        vc.estateID = items[indexPath.item].id
        show(vc, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @IBAction func addAgahiButtoTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func searchButtoNTapped(_ sender: Any) {
        let vc = SearchAgahiManTableViewController.create()
        vc.delegate = self
        show(vc, sender: nil)
    }
    
    
    func openPaymentVC(price: Int?, offPrice: Int?, estateID: String, type: Int) {
        let nav = UINavigationController.create(withId: "UINavigationControllerPayment") as! UINavigationController
        let vc = nav.viewControllers.first as! PaymentTableViewController
        vc.type = type
        vc.rcPayment = RCPaymentModel(price: price, discountPrice: offPrice)
        vc.estateID = estateID
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

extension AgahiManTableViewController: SearchAgahiManTableViewControllerDelegate {
    func searchDone(_ query: [String: String]) {
        fetch(query: query)
    }
}

extension AgahiManTableViewController: AgahiManTableViewCellDelegate {
    func deleteButtonTapped(cell: AgahiManTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let vc = RemoveAgahiViewController()
            vc.id = self.items[indexPath.item].id
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func editButtonTapped(cell: AgahiManTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let vc = AddAgahiStep2TableViewController.create()
            vc.isUpdate = true
            vc.updateEstateID = items[indexPath.item].id
            show(vc, sender: nil)
        }
    }
    
    func payButtonTapped(cell: AgahiManTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let item = items[indexPath.item]
            if item.status == 4 {
                // MARK: - RCAgahiManModel
                struct RC: Codable {
                    let categoryID: String?
                    let isFreeAddEstate: Bool?
                    let addEstatePrice, discountPrice: Int?

                    enum CodingKeys: String, CodingKey {
                        case categoryID = "categoryId"
                        case isFreeAddEstate, addEstatePrice, discountPrice
                    }
                }
                RestfulAPI<EMPTYMODEL,RC>.init(path: "/Estate/price-add/\(self.items[indexPath.item].estateUseID!)")
                .with(auth: .user)
                .with(method: .GET)
                    .sendURLSessionRequest { (result) in
                    DispatchQueue.main.async {
                        self.stopIndicatorAnimate()
                        switch result {
                        case .success(let res):
                            self.openPaymentVC(price: res.addEstatePrice, offPrice: res.discountPrice, estateID: self.items[indexPath.item].id!, type: 4)
                            self.navigationController?.popToRootViewController(animated: true)
                            break
                        case .failure(let err):
                            print(err)
                        }
                    }
                }
            } else {
                // TAMDID
                // MARK: - RCAgahiManModel
                struct RC: Codable {
                    let categoryID: String?
                    let isFreeAddEstate: Bool?
                    let addEstatePrice, discountPrice: Int?

                    enum CodingKeys: String, CodingKey {
                        case categoryID = "categoryId"
                        case isFreeAddEstate, addEstatePrice, discountPrice
                    }
                }
                RestfulAPI<EMPTYMODEL,RC>.init(path: "/Estate/price-add/\(self.items[indexPath.item].estateUseID!)")
                .with(auth: .user)
                .with(method: .GET)
                    .sendURLSessionRequest { (result) in
                    DispatchQueue.main.async {
                        self.stopIndicatorAnimate()
                        switch result {
                        case .success(let res):
                            self.openPaymentVC(price: res.addEstatePrice, offPrice: res.discountPrice, estateID: self.items[indexPath.item].id!, type: 5)
                            self.navigationController?.popToRootViewController(animated: true)
                            break
                        case .failure(let err):
                            print(err)
                        }
                    }
                }
            }
        }
    }
    
    func nardebanButtonTapped(cell: AgahiManTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            // MARK: - RC
            struct RC: Codable {
                let priceEnd, priceDiscount: Int?
            }

            RestfulAPI<EMPTYMODEL,RC>.init(path: "/Common/price-ladder")
            .with(auth: .user)
            .with(method: .GET)
                .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.openPaymentVC(price: res.priceEnd, offPrice: res.priceDiscount, estateID: self.items[indexPath.item].id!, type: 2)
                        self.navigationController?.popToRootViewController(animated: true)
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
        }
    }
    
    func vjiheButtonTapped(cell: AgahiManTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            // MARK: - RC
            struct RC: Codable {
                let priceEnd, priceDiscount: Int?
            }

            RestfulAPI<EMPTYMODEL,RC>.init(path: "/Common/price-vip")
            .with(auth: .user)
            .with(method: .GET)
                .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.openPaymentVC(price: res.priceEnd, offPrice: res.priceDiscount, estateID: self.items[indexPath.item].id!, type: 3)
                        self.navigationController?.popToRootViewController(animated: true)
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
        }
    }
}

extension AgahiManTableViewController: RemoveAgahiViewControllerDelegate {
    func doneRemove() {
        self.fetch(query: [:])
    }
}

public enum EstateStatusEnum: Int
 {
     case Pending = 0
     case Review = 1
     case Approve = 2
     case Failed = 3
     case PendingPay = 4
     case EditedPending = 5
          
    func title() -> String {
        switch self {
        case .Pending:
            return "در حال بررسی"
        case .Review:
            return  "در حال بررسی"
        case .Approve:
            return "تایید شده"
        case .Failed:
            return "تایید نشده"
        case .PendingPay:
            return "در انتظار پرداخت"
        case .EditedPending: return  "در انتظار ویرایش"
        }
    }
 }

/*
 [
   {
     "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
     "category": "string",
     "childCategory": "string",
     "type": 0,
     "province": "string",
     "city": "string",
     "userId": "string",
     "ownerName": "string",
     "estateUseId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
     "title": "string",
     "priceBuy": 0,
     "priceRent": 0,
     "priceMortgage": 0,
     "isMortgage": true,
     "isAgreementPriceBuy": true,
     "isAgreementPriceRent": true,
     "isAgreementPriceMortgage": true,
     "address": "string",
     "status": 0, /////  public enum EstateStatusEnum ******* vaziyate agahi *******
     "isUpdated": true,
     "img": "string",
     "modifiedDate": "2021-08-04T16:34:16.876Z",
     "key": 0,
     "isLadder": true,
     "ladderExpireDate": "2021-08-04T16:34:16.876Z",
     "isVip": true,
     "vipExpireDate": "2021-08-04T16:34:16.876Z",
     "expireDate": "2021-08-04T16:34:16.876Z",
     "isFreeAdd": true,
     "updatedDate": "2021-08-04T16:34:16.876Z",
     "isSold": true,
     "visitCount": 0
   }
 ]
 */

// shart nardeban
/*
 /api/v{version}/Estate/ladder (faqat agar raygan bood baraye vijhe ham hamine)
 // agar poli bod bayad dargah mostaqim baz she:
 /api/v{version}/Common/price-ladder -> jahate gereftan price ladder
 
 
 @if (item.Status == 2 && (item.IsFreeAdd || (item.ExpireDate != null && item.ExpireDate.Value.Date > DateTime.Now.AddDays(5).Date)) && (!item.IsLadder || (item.IsLadder && item.LadderExpireDate < DateTime.Now)))
 */

// shart vije
/*
 /api/v{version}/Estate/ladder (faqat agar raygan bood baraye vijhe ham hamine)
 /api/v{version}/Common/price-vip  -> jahate gereftan price vijhe
 
 (item.Status == 2 && (item.IsFreeAdd || (item.ExpireDate != null && item.ExpireDate.Value.Date > DateTime.Now.AddDays(5).Date)) && (!item.IsVip || (item.IsVip && item.VipExpireDate < DateTime.Now)))
 */


//tamdid:
/*
 
 @if (item.Status != 4 && (!item.IsFreeAdd && item.ExpireDate != null && item.ExpireDate < DateTime.Now.AddDays(5)))
                                                 {
                                                     <a onclick="OnEx('@(item.Id)')" class="btn btn-warning btn-shadow font-weight-bold mr-2">تمدید </a>
                                                 }
 */


// pardakht (faqat)
//status == 4
/*
 //estateUseId ID CATEGORY HAMON AGAHI
 /api/v{version}/Estate/price-add/{categoryId} -> jahate gereftan price agahi vase pardakht
 */



// MARK: - RCAgahiManModelElement
struct RCAgahiManModelElement: Codable {
    let id, category, childCategory: String?
    let type: Int?
    let province, city, userID, ownerName: String?
    let estateUseID, title: String?
    let priceBuy, priceRent, priceMortgage: Int?
    let isMortgage, isAgreementPriceBuy, isAgreementPriceRent, isAgreementPriceMortgage: Bool?
    let address: String?
    let status: Int?
    let isUpdated: Bool?
    let img, modifiedDate: String?
    let key: Int?
    let isLadder: Bool?
    let ladderExpireDate: String?
    let isVip: Bool?
    let vipExpireDate, expireDate: String?
    let isFreeAdd: Bool?
    let updatedDate: String?
    let isSold: Bool?
    let visitCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, category, childCategory, type, province, city
        case userID = "userId"
        case ownerName
        case estateUseID = "estateUseId"
        case title, priceBuy, priceRent, priceMortgage, isMortgage, isAgreementPriceBuy, isAgreementPriceRent, isAgreementPriceMortgage, address, status, isUpdated, img, modifiedDate, key, isLadder, ladderExpireDate, isVip, vipExpireDate, expireDate, isFreeAdd, updatedDate, isSold, visitCount
    }
}

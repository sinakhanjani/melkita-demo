//
//  FavoriteTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class FavoriteTableViewController: UITableViewController {
    
    var items = [Favorite]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "علاقه‌مندی های من"
        backBarButtonAttribute(color: .black, name: "")
        fetch()
    }
    
    func fetch() {
        RestfulAPI<EMPTYMODEL,[Favorite]>.init(path: "/FavoList")
        .with(auth: .user)
            .with(queries: ["Page":"1", "PageSize":"10000"])
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        let item = items[indexPath.item]
        // cell label 1 - 5 ->> 5:address
        // 1 name
        // 2 kharid
        // 3 rah
        // 4 ejare
        // 5 address
        // circleImageView 1
        cell.titleLabel1.text = item.title
        if let price = item.priceBuy, price > 0 {
            cell.titleLabel2.text = price.seperateByCama
        }
        if let price = item.priceMortgage, price > 0 {
            cell.titleLabel3.text = price.seperateByCama
        }
        if let price = item.priceRent, price > 0 {
            cell.titleLabel4.text = price.seperateByCama
        }
        cell.titleLabel5.text = item.address
        if let url = item.img {
            cell.circleImageView1.loadImageUsingCache(withUrl: url)
        }
        
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @IBAction func removeAllButtonTapped() {
        presentCDAlertWarningWithTwoAction(message: "آیا میخواهید تمام آگهی ها را حذف کنید؟", buttonOneTitle: "بله", buttonTwoTitle: "خیر") {
            RestfulAPI<EMPTYMODEL,GenericOrginal<EMPTYMODEL>>.init(path: "/FavoList/delete-all")
            .with(auth: .user)
                .with(method: .DELETE)
                .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        if res.isSuccess ?? false {
                            self.navigationController?.popViewController(animated: true)
                            self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                        }
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
        } handlerButtonTwo: {
            //NO
        }
    }
}

extension FavoriteTableViewController: TableViewCellDelegate {
    func button1Tapped(sender: UIButton, cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            // namayesh agahi
            let vc = AgahiTableViewController.create()
            vc.estateID = items[indexPath.item].id
            
            show(vc, sender: nil)
        }
    }
    
    func button2Tapped(sender: UIButton, cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            // hazfe agahi
            RestfulAPI<EMPTYMODEL,GenericOrginal<EMPTYMODEL>>.init(path: "/FavoList/\(items[indexPath.item].id!)")
            .with(auth: .user)
                .with(method: .DELETE)
                .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        if res.isSuccess ?? false {
                            self.fetch()
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
}


// MARK: - Element
struct Favorite: Codable {
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

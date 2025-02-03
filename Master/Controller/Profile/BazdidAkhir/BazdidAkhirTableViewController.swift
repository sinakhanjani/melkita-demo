//
//  BazdidAkhirTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class BazdidAkhirTableViewController: UITableViewController {
    
    var items = [VisitElement]()

    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .black, name: "")
        fetch()
    }
    
    func fetch() {
        RestfulAPI<EMPTYMODEL,[VisitElement]>.init(path: "/User/estate/visited")
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
    
    @IBAction func deleteAllButtonTapped(_ sender: Any) {
        presentCDAlertWarningWithTwoAction(message: "آیا میخواهید تمام آگهی ها را حذف کنید؟", buttonOneTitle: "بله", buttonTwoTitle: "خیر") {
            RestfulAPI<EMPTYMODEL,GenericOrginal<EMPTYMODEL>>.init(path: "/User/estate/visited/deleteall")
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
        } handlerButtonTwo: {
            //NO
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        let item = items[indexPath.item]
        cell.titleLabel1.text = item.title
        if let price = item.priceBuy, price > 0 {
            cell.titleLabel2.text = price.seperateByCama
        }
        if let price = item.priceMortgage, price > 0 {
            cell.titleLabel2.text = price.seperateByCama
        }
        if let price = item.priceRent, price > 0 {
            cell.titleLabel2.text = price.seperateByCama
        }
        if let imgAddress = item.img {
            cell.circleImageView1.loadImageUsingCache(withUrl: imgAddress)
        }
        cell.titleLabel5.text = item.address

        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension BazdidAkhirTableViewController: TableViewCellDelegate {
    func button1Tapped(sender: UIButton, cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            // show agahi
            let item = items[indexPath.item]
            let vc = AgahiTableViewController.create()
            vc.estateID = item.estateID
            show(vc, sender: nil)
        }
    }
    
    func button2Tapped(sender: UIButton, cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            // delet from recent list
            let item = items[indexPath.item]
            RestfulAPI<EMPTYMODEL,GenericOrginal<EMPTYMODEL>>.init(path: "/User/estate/visited/delete/\(items[indexPath.item].reviewID!)")
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
struct VisitElement: Codable {
    let reviewID, estateID, address, city: String?
    let province: String?
    let key: Int?
    let img, title: String?
    let type: Int?
    let userID: String?
    let metr, countRoom, priceBuy, priceRent: Int?
    let priceMortgage: Int?
    let isMortgage, isAgreementPriceBuy, isAgreementPriceRent, isAgreementPriceMortgage: Bool?
    let isNewAge, isSold: Bool?

    enum CodingKeys: String, CodingKey {
        case reviewID = "reviewId"
        case estateID = "estateId"
        case address, city, province, key, img, title, type
        case userID = "userId"
        case metr, countRoom, priceBuy, priceRent, priceMortgage, isMortgage, isAgreementPriceBuy, isAgreementPriceRent, isAgreementPriceMortgage, isNewAge, isSold
    }
}

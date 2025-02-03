//
//  KharidBaCodeManTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/23/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class KharidBaCodeManTableViewController: UITableViewController {

    var items = [KharidElemntElement]()

    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .black, name: "")
        title = "خرید با کد معرف من"
        fetch()
    }
    
    func fetch() {
        RestfulAPI<Empty,[KharidElemntElement]>.init(path: "/Marketer/buy")
        .with(auth: .user)
        .with(method: .GET)
        .with(queries: ["Page":"1", "PageSize":"10000"])
        .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
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
        cell.titleLabel2.text = item.shopperName
        cell.titleLabel3.text = item.shopperPhoneNumber
        cell.titleLabel4.text = (item.priceEnd?.seperateByCama ?? "") + " تومان"
        cell.titleLabel5.text = (item.profit?.seperateByCama ?? "") + " تومان"
        cell.titleLabel6.text = item.createDate?.persianDateWithFormat("YYYY/MM/dd hh:mm")
    
        cell.titleLabel7.text = item.description

        return cell
    }
}

// MARK: - MoarefElemntElement
struct KharidElemntElement: Codable {
    let id, createDate, modifiedDate, marketerId: String?
    let userId: String?
    let priceEnd, profit: Int?
    let description, shopperName, shopperPhoneNumber: String?

}

//
//  MoarefanManTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/23/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class MoarefanManTableViewController: UITableViewController {

    var items = [MoarefElemntElement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .black, name: "")
        title = "معرفان من"
        fetch()
    }
    
    func fetch() {
        RestfulAPI<Empty,[MoarefElemntElement]>.init(path: "/Marketer/intro")
        .with(auth: .user)
        .with(method: .GET)
        .with(queries: ["Page":"1", "PageSize":"100000"])
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
        if let name = item.firstName, let last = item.lastName {
            cell.titleLabel2.text = "\(name) \(last)"
        }
        cell.titleLabel3.text = item.phoneNumber //2
        cell.titleLabel4.text = item.nationalCode //3
        cell.titleLabel5.text = "\(item.orderCount ?? 0)"
        cell.titleLabel6.text = "\(item.key ?? 0)"
        cell.circleImageView1.loadImageUsingCache(withUrl: item.photoUrl ?? "")
        return cell
    }
}


// MARK: - MoarefElemntElement
struct MoarefElemntElement: Codable {
    let id, userId: String?
    let key, orderCount: Int?
    let nationalCode, modifiedDate, firstName, lastName: String?
    let photoUrl, phoneNumber: String?


}

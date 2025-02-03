//
//  ArchiveVariziTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/23/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class ArchiveVariziTableViewController: UITableViewController, FilterArchiveVariziTableViewControllerDelegate {

    var items = [ArchiveSingle]()
    
    var query: [String:String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .black, name: "")
        title = "آرشیو واریزی"
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        addBarButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = addBarButton
        if let query = self.query {
            self.fetch(query: query)
        } else {
            fetch(query: [:])
        }
    }
    
    @objc func searchButtonTapped() {
        let vc = FilterArchiveVariziTableViewController.create()
        vc.delegate = self
        show(vc, sender: nil)
    }
    
    func searchDone(query: [String : String]) {
        fetch(query: query)
    }

    func fetch(query: [String:String]) {
        var queries = query
        queries.updateValue("1", forKey: "Page")
        queries.updateValue("1000", forKey: "PageSize")
        RestfulAPI<Empty,[ArchiveSingle]>.init(path: "/Marketer/deposit")
        .with(auth: .user)
        .with(method: .GET)
            .with(queries: queries)
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

        if let status = item.status, let type = DepositStatusEnum(rawValue: status) {
            cell.titleLabel1.text = type.name()
            if case .Approve = type {
                cell.bgView1.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.3978117858, blue: 0.1953154064, alpha: 1)
            } else {
                cell.bgView1.backgroundColor = .orange
            }
        } else {
            cell.bgView1.backgroundColor = .orange
        }
        cell.titleLabel2.text = "\(item.trackingCode ?? "-")"
        cell.titleLabel3.text = (item.price?.seperateByCama ?? "") + " تومان"
        if let type = item.type {
            if type == 0 {
                cell.titleLabel4.text = "واریز به کیف پول"
            } else {
                cell.titleLabel4.text = "واریز به حساب بانکی"
            }
        }
        cell.titleLabel5.text = item.depositorName
        cell.titleLabel5.text = item.createDate?.persianDateWithFormat("YYYY/MM/dd hh:mm")
        cell.titleLabel6.text = item.zarinPalPayoutId
        
        return cell
    }
}


// MARK: - SinglePackageElement
struct ArchiveSingle: Codable {
    let id, createDate, modifiedDate, zarinPalPayoutId: String?
    let userId: String?
    let price, key, status, type: Int?
    let bankCardId, bankCardNumber, paymentDate, trackingCode: String?
    let depositorName, bank: String?

}

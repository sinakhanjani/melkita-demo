//
//  BankListTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/23/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class BankListTableViewController: UITableViewController, TableViewCellDelegate {
    
    var items = [BankCardElement]()

    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .black, name: "")
        title = "حساب های بانکی من"
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addBarButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = addBarButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchBanks()
    }
    
    func fetchBanks() {
        RestfulAPI<Empty,[BankCardElement]>.init(path: "/BankCard")
        .with(auth: .user)
        .with(method: .GET)
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
        cell.delegate = self
        cell.titleLabel1.text = item.bankName
        if let status = item.status, let type = DepositStatusEnum(rawValue: status) {
            cell.titleLabel2.text = type.name()
            if case .Approve = type {
                cell.bgView1.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.3978117858, blue: 0.1953154064, alpha: 1)
            } else {
                cell.bgView1.backgroundColor = .orange
            }
        } else {
            cell.bgView1.backgroundColor = .orange
        }
        
        cell.titleLabel3.text = item.cardNumber
        cell.titleLabel4.text = item.shaba

        
        return cell
    }
    
    
    func button1Tapped(sender: UIButton, cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            // edit
            let item = items[indexPath.item]
            let vc = CreateBankTableViewController.create()
            vc.item = item
            show(vc, sender: nil)
        }
    }
    
    @objc func addButtonTapped() {
        let vc = CreateBankTableViewController.create()
        show(vc, sender: nil)
    }
}

// MARK: - BankCardElement
struct BankCardElement: Codable {
    let id, createDate, modifiedDate, zarinpalCardId: String?
    let userId, firstName, lastName, bankName: String?
    let shaba, cardNumber: String?
    let status: Int?
    let reasonForRejection: String?
    let isDelete: Bool?
}

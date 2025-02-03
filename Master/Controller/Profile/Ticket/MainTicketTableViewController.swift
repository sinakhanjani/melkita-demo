//
//  MainTicketTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class MainTicketTableViewController: UITableViewController {
    
    var items = [Ticket]()

    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .black, name: "")
        title = "تیکت‌های من"
        fetch()
    }
    
    func fetch() {
        RestfulAPI<EMPTYMODEL,[Ticket]>.init(path: "/Ticket")
        .with(auth: .user)
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
        cell.delegate = self
        let item = items[indexPath.item]
        cell.titleLabel1.text = "شماره تیکت: \(item.ticketNumber ?? 0)"
        if let status = item.status, let statusEnum = StatusTicketEnum.init(rawValue: status) {
            cell.titleLabel2.text = "وضعیت: \(statusEnum.name())"
            cell.bgView1.backgroundColor = statusEnum.color()
        }
        cell.titleLabel3.text = item.title
        if let level = item.level,let levenEnum = LevelTicketEnum.init(rawValue: level) {
            cell.titleLabel4.text = levenEnum.name()
        }
        if let department = item.department,let depEnum = DepartmentTicketEnum.init(rawValue: department) {
            cell.titleLabel5.text = depEnum.name()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TicketDetailTableViewController.create()
        vc.ticketNumber = items[indexPath.item].ticketNumber
        vc.id = items[indexPath.item].id
        
        show(vc, sender: nil)
    }
}

extension MainTicketTableViewController: TableViewCellDelegate {
    func button1Tapped(sender: UIButton, cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
        }
    }
}

// MARK: - Element
struct Ticket: Codable {
    let id, createDate, modifiedDate, userID: String?
    let title: String?
    let department, ticketNumber: Int?
    let estateID: String?
    let estateKey, status, level: Int?
    let read: Bool?

    enum CodingKeys: String, CodingKey {
        case id, createDate, modifiedDate
        case userID = "userId"
        case title, department, ticketNumber
        case estateID = "estateId"
        case estateKey, status, level, read
    }
}

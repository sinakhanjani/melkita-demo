//
//  TicketDetailTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/12/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class TicketDetailTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shomareTicketLabel: UILabel!
    @IBOutlet weak var vaziyatLabel: UILabel!
    @IBOutlet weak var mozoLabel: UILabel!
    @IBOutlet weak var bakhshLabel: UILabel!
    @IBOutlet weak var olaviyatLabel: UILabel!
    @IBOutlet weak var bgView: UIView!

    var ticketDetail: TicketDetail?
    
    var ticketNumber: Int?
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "مشاهده تیکت"
        backBarButtonAttribute(color: .black, name: "")
        if let ticketNumber = self.ticketNumber {
            fetch(id: ticketNumber)
        }
    }
    
    func updateUI(item: TicketDetail) {
        self.shomareTicketLabel.text = "شماره تیکت: \(item.ticketNumber ?? 0)"
        if let status = item.status, let statusEnum = StatusTicketEnum.init(rawValue: status) {
            self.vaziyatLabel.text = statusEnum.name()
            self.bgView.backgroundColor = statusEnum.color()
        }
        mozoLabel.text = item.title
        if let level = item.level,let levenEnum = LevelTicketEnum.init(rawValue: level) {
            olaviyatLabel.text = levenEnum.name()
        }
        if let department = item.department,let depEnum = DepartmentTicketEnum.init(rawValue: department) {
            bakhshLabel.text = depEnum.name()
        }
    }
    
    func fetch(id: Int) {
        RestfulAPI<EMPTYMODEL,TicketDetail>.init(path: "/Ticket/detail/\(id)")
        .with(auth: .user)
            .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                self.stopIndicatorAnimate()
                switch result {
                case .success(let res):
                    self.ticketDetail = res
                    self.updateUI(item: res)
                    self.tableView.reloadData()
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    @IBAction func closeTicketBugttonTapepd(_ sender: Any) {
        guard let id = self.id else { return }
        // MARK: - Empty
        struct Send: Codable {
            let id: String
        }
        self.startIndicatorAnimate()
        RestfulAPI<Send,GenericOrginal<EMPTYMODEL>>.init(path: "/Ticket/close")
        .with(auth: .user)
            .with(method: .PATCH)
            .with(body: Send(id: id))
            .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                self.stopIndicatorAnimate()
                switch result {
                case .success(let res):
                    if res.isSuccess == true {
                        self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                    }
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    @IBAction func sendAwnserButtonTapped(_ sender: Any) {
        let vc = AwnserTicketTableViewController.create()
        vc.ticketID = id
        show(vc, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ticketDetail?.messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        if let item = self.ticketDetail?.messages?[indexPath.item] {
            if item.senderAdmin == true {
                cell.titleLabel1.text = item.adminName
            } else {
                if let name = DataManager.shared.userProfile?.data?.firstName, let family = DataManager.shared.userProfile?.data?.lastName {
                    cell.titleLabel1.text = "\(name) \(family)"
                }
            }
            cell.titleLabel2.text = item.createDate?.persianDateWithFormat("YYYY/MM/dd")
            cell.titleLabel3.text = item.message
            cell.delegate = self
            if let files = item.attach, !files.isEmpty {
                cell.button1.alpha = 1
            } else {
                cell.button1.alpha = 0
            }
        }
        // 1 = name
        // 2 // date
        // 3 message
        if let photoURL = DataManager.shared.userProfile?.data?.photoURL {
            cell.imageView1.loadImageUsingCache(withUrl: photoURL)
        }
        
        return cell
    }
    
    func button1Tapped(sender: UIButton, cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            if let files = self.ticketDetail?.messages?[indexPath.item].attach, !files.isEmpty {
                let vc = FileTableViewController.create()
                vc.items = files
                show(vc, sender: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}


// MARK: - Empty
struct TicketDetail: Codable {
    let ticketID, title: String?
    let department, ticketNumber, status, level: Int?
    let read: Bool?
    let createDate, modifiedDate: String?
    let messages: [TicketMessage]?

    enum CodingKeys: String, CodingKey {
        case ticketID = "ticketId"
        case title, department, ticketNumber, status, level, read, createDate, modifiedDate, messages
    }
}

// MARK: - Message
struct TicketMessage: Codable {
    let message, createDate: String?
    let senderAdmin: Bool?
    let adminPhoto, adminName: String?
    let attach: [String]?
}

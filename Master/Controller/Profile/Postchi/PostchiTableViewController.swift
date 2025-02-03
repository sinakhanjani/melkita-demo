//
//  PostchiTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class PostchiTableViewController: UITableViewController {
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "پستچی ملکیتا"
        backBarButtonAttribute(color: .black, name: "")
        fetchUserPackage()
    }
    
    func fetchUserPackage() {
        RestfulAPI<EMPTYMODEL,Messages>.init(path: "/Message/messages")
        .with(auth: .user)
            .with(queries: ["Page":"1", "PageSize":"10000"])
            .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                self.stopIndicatorAnimate()
                switch result {
                case .success(let res):
                    self.messages = res.messages ?? []
                    self.tableView.reloadData()
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        let item = messages[indexPath.item]
        if let status = item.type, let typeEnum = MessageTypeEnum.init(rawValue: status) {
            cell.titleLabel1.text = typeEnum.name()
            cell.circleImageView1.tintColor = typeEnum.color()
        }
        cell.titleLabel2.text = item.createDate?.persianDateWithFormat("YYYY/MM/dd")
        cell.button1.alpha = (item.isRead ?? false) ? 0:1
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PostchiDetailTableViewController.create()
        vc.id = messages[indexPath.item]
        show(vc, sender: nil)
    }
}

public enum MessageTypeEnum: Int
 {
     case Info = 0 // etala resani (blue)
     case Error = 1 // khata (red)
     case Warning = 2 // ekhtar (orange)
    
    func color() -> UIColor {
        switch self {
        case .Info:
            return .blue
        case .Error:
            return .red
        case .Warning:
            return .orange
        }
    }
    
    func name() -> String {
        switch self {
        case .Info:
            return "اطلاع رسانی"
        case .Error:
            return "خطا"
        case .Warning:
            return "اخطار"
        }
    }
 }


// MARK: - Empty
struct Messages: Codable {
    let countUnRead: Int?
    let messages: [Message]?
}

// MARK: - Message
struct Message: Codable {
    let id: String?
    let senderAdminID, userID: String?
    let isRead: Bool?
    let type: Int?
    let isUserRecive, isEstateAdvisorRecive, isMarketerRecive, isSystem: Bool?
    let title, text, messageDescription: String?
    let createDate: String?
    enum CodingKeys: String, CodingKey {
        case id
        case senderAdminID = "senderAdminId"
        case userID = "userId"
        case isRead, type, isUserRecive, isEstateAdvisorRecive, isMarketerRecive, isSystem, title, text
        case messageDescription = "description"
        case createDate
    }
}

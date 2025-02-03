//
//  MainChatViewController.swift
//  Master
//
//  Created by Sina khanjani on 4/30/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

// MARK: - ChatElement
struct ChatElement: Codable {
    let id, senderName, senderPhoto, reciverName: String?
    let reciverPhoto, modifiedDate, receiverID, senderID: String?
    let read: Bool?
    let chatUnReadCount: Int?
    let firstMessage: String?

    enum CodingKeys: String, CodingKey {
        case id, senderName, senderPhoto, reciverName, reciverPhoto, modifiedDate
        case receiverID = "receiverId"
        case senderID = "senderId"
        case read, chatUnReadCount, firstMessage
    }
}

typealias Chats = [ChatElement]


class MainChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var chats = Chats()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .black, name: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !Authentication.user.isLogin {
            self.tabBarController?.selectedIndex = 0
            return
        }
        
        fetchNotifi()
        fetchChats()
    }
    
    func fetchChats() {
        RestfulAPI<EMPTYMODEL,Chats>.init(path: "/Chat")
            .with(queries: ["Page":"1", "PageSize":"10000"])
            .with(method: .GET)
            .with(auth: .user)
            .sendURLSessionRequest { result in
                DispatchQueue.main.async {
                    if case .success(let res) = result {
                        self.chats = res
                        self.tableView.reloadData()
                        }
                    }
                }
            }
    
    func removeChat(id: String) {
        RestfulAPI<EMPTYMODEL,GenericOrginal<EMPTYMODEL>>.init(path: "/Chat/delete-history")
            .with(method: .DELETE)
            .with(queries: ["ChatId":id])
            .with(auth: .user)
            .sendURLSessionRequest { result in
                DispatchQueue.main.async {
                    if case .success(let res) = result {
                        if let msg = res.msg {
                            self.presentCDAlertWarningAlert(message: msg, completion: {})
                            self.fetchChats()
                        }
                    }
                }
            }
    }
    
    func fetchNotifi() {
        // MARK: - Notif
        struct Notif: Codable {
            let messageUnReadCount, ticketUnReadCount, chatUnReadCount: Int?
        }

        RestfulAPI<EMPTYMODEL,Notif>.init(path: "/User/notification")
            .with(method: .GET)
            .with(auth: .user)
            .sendURLSessionRequest { result in
                DispatchQueue.main.async {
                    if case .success(let res) = result {
                        if let items = self.tabBarController?.tabBar.items {
                            if let count = res.chatUnReadCount, count > 0 {
                                items[1].badgeValue = "\(count)"
                                items[1].badgeColor = .red
                                let adad = (res.messageUnReadCount ?? 0) + (res.ticketUnReadCount ?? 0)
                                if adad > 0 {
                                    items[0].badgeValue = "\(adad)"
                                    items[0].badgeColor = .red
                                }
                            } else {
                                items[1].badgeValue = nil
                                items[1].badgeColor = nil
                                let adad = (res.messageUnReadCount ?? 0) + (res.ticketUnReadCount ?? 0)
                                if adad <= 0 {
                                    items[0].badgeValue = nil
                                    items[0].badgeColor = nil
                                }
                                if adad > 0 {
                                    items[0].badgeValue = "\(adad)"
                                    items[0].badgeColor = .red
                                }
                            }
                        }
                    }
                }
            }
    }
}

extension MainChatViewController: UITableViewDelegate, UITableViewDataSource, TableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.delegate = self
        let item = chats[indexPath.item]
        
        cell.titleLabel1.text = item.reciverName
        cell.titleLabel2.text = item.firstMessage
        cell.titleLabel3.text = item.modifiedDate?.persianDate()
        if let count = item.chatUnReadCount, count > 0 {
            cell.titleLabel4.text = "\(count)"
            cell.bgView1.alpha = 1
        } else {
            cell.bgView1.alpha = 0
        }
        if let url = item.reciverPhoto {
            cell.circleImageView1.loadImageUsingCache(withUrl: url)

        }
        
        return cell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatTableViewController.create()
        vc.chat = chats[indexPath.item]
        
        show(vc, sender: nil)
    }
    
    func button1Tapped(sender: UIButton, cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            presentCDAlertWarningWithTwoAction(message: "آیا میخواید این گفتگو را حذف کنید؟", buttonOneTitle: "بله", buttonTwoTitle: "خیر") {
                if let id = self.chats[indexPath.item].id {
                    self.removeChat(id: id)
                }
            } handlerButtonTwo: {
                
            }

        }
    }
}

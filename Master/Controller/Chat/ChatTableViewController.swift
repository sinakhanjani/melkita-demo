//
//  ChatTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 4/30/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI
//receiver
//sender


// MARK: - ConversationElement
struct ConversationElement: Codable {
    let id, chatID, senderName, senderPhoto: String?
    let createDate: String?
    let read: Bool?
    let text, senderID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case chatID = "chatId"
        case senderName, senderPhoto, createDate, read, text
        case senderID = "senderId"
    }
}

typealias Conversations = [ConversationElement]


class ChatTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sendMessageView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var chat: ChatElement?
    var receiverID: String?
    
    var conversations = Conversations()
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = chat?.reciverName ?? "گفتگو"
        // com from chat tab
        if let chat = chat {
            if let id = chat.id {
                readRequest(id: id)
                fetchMessages(id: id)
            }
        }
        // come from agahi
        if let id = receiverID {
            readRequest(id: id)
            self.fetchMessages(id: id)
        }
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true, block: { _ in
            if let chat = self.chat {
                if let id = chat.id {
                    self.fetchMessages(id: id)
                }
            }
            // come from agahi
            if let id = self.receiverID {
                self.fetchMessages(id: id)
            }
        })
        self.view.bindToKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    func readRequest(id: String) {
        RestfulAPI<EMPTYMODEL,EMPTYMODEL>.init(path: "/Chat/read/\(id)")
            .with(method: .GET)
            .with(auth: .user)
            .sendURLSessionRequest { result in
                DispatchQueue.main.async {
//                    if case .success(let res) = result {
//
//                        }
                    }
                }
    }
    
    func fetchMessages(id: String) {
        RestfulAPI<EMPTYMODEL,Conversations>.init(path: "/Chat/message")
            .with(method: .GET)
            .with(queries: ["Page":"1", "PageSize":"10000", "ChatOrReceiverId":id])
            .with(auth: .user)
            .sendURLSessionRequest { result in
                DispatchQueue.main.async {
                    if case .success(let res) = result {
                        self.conversations = res
                        self.tableView.reloadData()
                        }
                    }
                }
    }
    
    @IBAction func sendMessgeTapped(_ sender: Any) {
        guard let text = messageTextField.text, text.count > 0 else { return }
        // MARK: - Send
        struct Send: Codable {
            let reciverOrChatID, text: String
            let isReply: Bool

            enum CodingKeys: String, CodingKey {
                case reciverOrChatID = "reciverOrChatId"
                case text, isReply
            }
        }
        
        let isReply = (receiverID == nil) ? true:false
        let id = (receiverID != nil) ? receiverID!: (chat?.id ?? "")
        
        self.messageTextField.text = ""
        RestfulAPI<Send,GenericOrginal<EMPTYMODEL>>.init(path: "/Chat")
            .with(method: .POST)
            .with(auth: .user)
            .with(body: Send(reciverOrChatID: id, text: text, isReply: isReply))
            .sendURLSessionRequest { result in
                DispatchQueue.main.async {
                    if case .success(let res) = result {
                        if res.isSuccess == true {
                            self.fetchMessages(id: id)
                            }
                        }
                    }
                }
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = conversations[indexPath.item]
        if let userID = DataManager.shared.userProfile?.data?.id {
            if userID == item.senderID {
                // khodam
                let cell = tableView.dequeueReusableCell(withIdentifier: "sender") as! TableViewCell
                cell.titleLabel1?.text = item.text
                cell.titleLabel2?.text = item.createDate?.persianDate()
                
                return cell
            } else {
                // yaro
                let cell = tableView.dequeueReusableCell(withIdentifier: "receiver") as! TableViewCell
                cell.titleLabel1?.text = item.text
                cell.titleLabel2?.text = item.createDate?.persianDate()

                return cell
            }
        }
        
        return UITableViewCell()
    }

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//
//  AwnserTicketTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/12/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class AwnserTicketTableViewController: UITableViewController {
    
    @IBOutlet weak var textVIew: UITextView!
    
    var ticketID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "پاسخ به تیکت"
        backBarButtonAttribute(color: .black, name: "")
        textVIew.font = UIFont.persianFont(size: 17)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard !textVIew.text!.isEmpty else {
            presentCDAlertWarningAlert(message: "لطفا متن خود را وارد کنید", completion: {})
            return
        }
        guard let id = self.ticketID else { return }
        self.startIndicatorAnimate()
        RestfulAPI<File,GenericOrginal<EMPTYMODEL>>.init(path: "/Ticket/reply")
        .with(auth: .user)
            .with(method: .POST)
            .with(body: File(key: "Photo", data: Data()))
            .with(parameters: ["TicketId":id,
                               "Text":textVIew.text!])
            .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                self.stopIndicatorAnimate()
                switch result {
                case .success(let res):
                    if res.isSuccess == true {
                        self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
}

//
//  PostchiDetailTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI


class PostchiDetailTableViewController: UITableViewController {
    
    var id: Message?

    @IBOutlet weak var imageView: CircleImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var dateLabl: UILabel!
    @IBOutlet weak var descriptionLAbel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "مشاهده پیام"
        backBarButtonAttribute(color: .black, name: "")
        if let message = id {
            if let status = message.type, let typeEnum = MessageTypeEnum.init(rawValue: status) {
                self.imageView.tintColor = typeEnum.color()
                self.topLabel.text = message.title
                self.descriptionLAbel.text = message.text
                self.dateLabl.text = message.createDate?.persianDateWithFormat("YYYY/MM//dd")
            }
        }
        if let id = id?.id {
            fetchUserPackage(id: id)
        }
    }
    
    func fetchUserPackage(id: String) {
        RestfulAPI<EMPTYMODEL,GenericOrginal<EMPTYMODEL>>.init(path: "/Message/\(id)")
        .with(auth: .user)
            .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                self.stopIndicatorAnimate()
                switch result {
                case .success(let _):

                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
}

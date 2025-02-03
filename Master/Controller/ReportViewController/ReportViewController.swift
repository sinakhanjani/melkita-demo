//
//  ReportViewController.swift
//  Master
//
//  Created by Sina khanjani on 4/25/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class ReportViewController: UIViewController {

    @IBOutlet weak var titleLabl: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var id: String?
    var key: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabl.text = "ثبت تخلف برای آگهی تجاری شماره \(key ?? 0)"
        view.dismissedKeyboardByTouch()
        // Do any additional setup after loading the view.
        textView.becomeFirstResponder()
    }
    
    func sendReq(id: String) {
        // MARK: - RCSendCommentModel
        struct Send: Codable {
            let text, estateID: String
            let estateKey: Int

            enum CodingKeys: String, CodingKey {
                case text
                case estateID = "estateId"
                case estateKey
            }
        }

        
        RestfulAPI<Send,Generic>.init(path: "/Estate/report")
            .with(auth: .user)
            .with(method: .POST)
            .with(body: Send(text: textView.text!, estateID: id , estateKey: key ?? 0))
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {
                            self.dismiss(animated: true, completion: {})
                        })
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        if let id = id, let _ = key {
            sendReq(id: id)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}

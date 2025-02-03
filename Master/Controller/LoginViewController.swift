//
//  LoginViewController.swift
//  Master
//
//  Created by Sina khanjani on 2/31/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

struct SendMobile: Codable {
    let phoneNumber: String
}

struct MobileRecieved: Codable {
    let isSuccess: Bool
    let msg: String?
    let code: Int?
}

class LoginViewController: AppViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.keyboardType = .asciiCapableNumberPad
        view.dismissedKeyboardByTouch()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard !self.phoneTextField.text!.isEmpty && (self.phoneTextField.text!.count == 11) else {
            self.presentCDAlertWarningAlert(message: "لطفا شماره همراه خود را به درستی و با صفر وارد کنید", completion: {})
            return
        }
        self.view.endEditing(true)
        self.startIndicatorAnimate()
        RestfulAPI<SendMobile,MobileRecieved>.init(path: "/Auth/send-verification").with(method: .POST).with(body: SendMobile(phoneNumber: self.phoneTextField.text!))
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                }
                switch result {
                case .success(let res):
                    if res.isSuccess {
                        DispatchQueue.main.async {
                            let vc = VerificationViewController.create()
                            vc.mobile = self.phoneTextField.text!
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.presentCDAlertWarningAlert(message: res.msg ?? "لطفا مجددا تلاشک نید", completion: {})
                        }
                    }
                case .failure(_):
                    break
                }
            }
    }
}

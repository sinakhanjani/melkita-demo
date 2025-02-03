//
//  EditPhoneTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/10/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class EditPhoneTableViewController: UITableViewController {

    @IBOutlet weak var phoneTextFiled: InsetTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .black, name: "")
        self.phoneTextFiled.placeholder = "شماره موبایل فعلی خود را وارد کنید"
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        struct Send: Codable {
            let phoneNumber: String
        }
        
        guard phoneTextFiled.text!.count == 11 else {
            presentCDAlertWarningAlert(message: "لطفا شماره همراه را به درستی وارد کنید", completion: {})
            return
        }
        view.endEditing(true)
        
        RestfulAPI<Send,GenericOrginal<EMPTYMODEL>>.init(path: "/Auth/send-verification")
            .with(method: .POST)
            .with(auth: .user)
            .with(body: Send(phoneNumber: phoneTextFiled.text!))
            .sendURLSessionRequest { result in
                if case .success(let res) = result {
                    DispatchQueue.main.async {
                        if res.isSuccess == true {
                            let vc = VerificationViewController.create()
                            vc.mobile = self.phoneTextFiled.text!
                            vc.isFromChangePhoneNumber = true
                            vc.show(vc, sender: nil)
                        } else {
                            self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                        }

                    }
                }
            }
    }
}
///api/v{version}/User/Change-PhoneNumber
///api/v{version}/Auth/send-verification
// reponse success
/*
 return Ok(new ResponseActionVm { IsSuccess = true, Msg = "شماره موبایل شما با موفقیت تغییر یافت" });
 */

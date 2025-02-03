//
//  VerificationViewController.swift
//  Master
//
//  Created by Sina khanjani on 3/3/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

struct LoginMobleSend: Codable {
    let phoneNumber: String
    let code: Int
}

// MARK: - MobileRecieved
struct LoginMobleReceived: Codable {
    let isSuccess: Bool
    let msg: String?
    let code: Int?
    let data: LoginMobleDataClass?
}

// MARK: - DataClass
struct LoginMobleDataClass: Codable {
    let key: Int?
    let id, userName, firstName, lastName: String?
    let phoneCenter: String?
    let isActive: Bool?
    let phoneNumber, companyName: String?
    let isDocument: Bool?
    let photoURL, role, nationalCode, email: String?
    let inventory: Int?
    let accessToken, refreshToken: String?
    let favos: [String]?

    enum CodingKeys: String, CodingKey {
        case key, id, userName, firstName, lastName, phoneCenter, isActive, phoneNumber, companyName, isDocument
        case photoURL = "photoUrl"
        case role, nationalCode, email, inventory, accessToken, refreshToken, favos
    }
}


class VerificationViewController: AppViewController {
    
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var codeTextField: InsetTextField!
    
    private let elapsedTimeInSecond = 5*60
    private var timer: TimerHelper?
    var mobile: String = ""
    var isFromChangePhoneNumber = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextField.keyboardType = .asciiCapableNumberPad
        setupTimer()
    }
    
    private func setupTimer() {
        resendButton.isEnabled = false
        resendButton.setTitleColor(.secondaryLabel, for: .normal)
        resendButton.setTitle("05:00", for: .normal)
        
        timer = nil
        timer = TimerHelper(elapsedTimeInSecond: elapsedTimeInSecond)
        timer?.start { [weak self] (minute,secend) in
            self?.resendButton.setTitle("\(minute):\(secend)", for: .normal)
            if self?.resendButton.title(for: .normal) == "00:00" {
                self?.resendButton.setTitle("ارسال مجدد کد تایید", for: .normal)
                self?.resendButton.setTitleColor(.black, for: .normal)
                self?.resendButton.isEnabled = true
            }
        }
    }
    
    func okI(res: LoginMobleReceived) {
        var auth = Authentication.user
        AppDelegate.updateFCMToken(token: AppDelegate.fcmToken)
        auth.register(with: res.data?.accessToken ?? "")
        DataManager.shared.refreshToken = res.data?.refreshToken ?? ""
        DataManager.shared.userProfile = res
        AppDelegate.fetchRole()
        AppDelegate.fetchUserInfoRequest()
        ErsalMadarekTableViewController.fetchDocumentStatus { _ in}
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func agreeButtonTapped() {
        guard !self.codeTextField.text!.isEmpty else {
            self.presentCDAlertWarningAlert(message: "لطفا کد تایید را وارد کنید", completion: {})
            return
        }
        self.view.endEditing(true)
        // send request
        if self.isFromChangePhoneNumber == false {
            self.startIndicatorAnimate()
            RestfulAPI<LoginMobleSend,LoginMobleReceived>.init(path: "/Auth/verify").with(method: .POST)
                .with(body: LoginMobleSend(phoneNumber: mobile, code: Int(codeTextField.text!)!))
                .sendURLSessionRequest { (resul) in
                    DispatchQueue.main.async {
                        self.stopIndicatorAnimate()
                    }
                    switch resul {
                    case .success(let res):
                        if res.isSuccess {
                            DispatchQueue.main.async {
                                self.okI(res: res)
                            }
                        }  else {
                            DispatchQueue.main.async {
                                self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                            }
                        }
                    case .failure(_):
                        break
                    }
                }
        } else {
            struct Send: Codable { let code:Int, phoneNumber: String }
            // from change phone number
            self.startIndicatorAnimate()
            RestfulAPI<Send,LoginMobleReceived>.init(path: "/User/Change-PhoneNumber")
                .with(method: .POST)
                .with(body: Send(code: Int(codeTextField.text!)!, phoneNumber: mobile))
                .sendURLSessionRequest { (resul) in
                    DispatchQueue.main.async {
                        self.stopIndicatorAnimate()
                    }
                    switch resul {
                    case .success(let res):
                        DispatchQueue.main.async {
                            self.okI(res: res)
                        }
                        break
                    case .failure(_):
                        break
                    }
                }
        }
    }

    @IBAction func resendButtonTapped() {
        setupTimer()
        RestfulAPI<SendMobile,MobileRecieved>.init(path: "/Auth/send-verification").with(method: .POST).with(body: SendMobile(phoneNumber: mobile))
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                }
                switch result {
                case .success(let res):
                    if res.isSuccess {
                        DispatchQueue.main.async {
                            self.presentCDAlertWarningAlert(message: "کد تایید ارسال شد", completion: {})
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
        // send request
    }
}

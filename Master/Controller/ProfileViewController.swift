//
//  ProfileViewController.swift
//  Master
//
//  Created by Sina khanjani on 2/31/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI


struct Notif: Codable {
    let messageUnReadCount, ticketUnReadCount, chatUnReadCount: Int?
}

class ProfileViewController: UITableViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginButton: RoundedButton!
    @IBOutlet weak var postchiCountLabel: UILabel!
    @IBOutlet weak var ticketCountLabel: UILabel!
    @IBOutlet weak var ticketCountView: UIView!
    @IBOutlet weak var postchiCountView: UIView!
    
    var isEnableContract = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .black, name: "")
        updateUI()
        tabBarController?.selectedIndex = 4
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
        fetchNotifi()
        fetchUserInfoRequest()
        AppDelegate.fetchRole()
        fetchContract()
        ErsalMadarekTableViewController.fetchDocumentStatus { _ in}
    }
    
    func fetchContract() {
        struct RES: Codable {
            let isDisableContractLinkApp: Bool
        }
        RestfulAPI<Empty,RES>.init(path: "/Common/contract-setting")
        .with(auth: .user)
        .with(method: .GET)
        .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let res):
                    self.isEnableContract = res.isDisableContractLinkApp
                    self.tableView.reloadData()
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    func fetchUserInfoRequest() {
        RestfulAPI<Empty,RCUserInfo>.init(path: "/User/info")
        .with(auth: .user)
        .with(method: .GET)
        .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let res):
                    DataManager.shared.userInfo = res
                    self.tableView.reloadData()
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    func updateNotifUI(res: Notif) {
        if let items = self.tabBarController?.tabBar.items {
            if let count = res.chatUnReadCount, count > 0 {
                items[1].badgeValue = "\(count)"
                items[1].badgeColor = .red
                let adad = (res.messageUnReadCount ?? 0) + (res.ticketUnReadCount ?? 0)
                if (res.messageUnReadCount ?? 0) > 0 {
                    self.postchiCountView.alpha = 1
                    self.postchiCountLabel.text = "\(res.messageUnReadCount ?? 0)"
                } else {
                    self.postchiCountView.alpha = 0
                }
                
                if (res.ticketUnReadCount ?? 0) > 0 {
                    self.ticketCountLabel.text = "\(res.ticketUnReadCount ?? 0)"
                    self.ticketCountView.alpha = 1
                } else {
                    self.ticketCountView.alpha = 0
                }
                if adad > 0 {
                    items[0].badgeValue = "\(adad)"
                    items[0].badgeColor = .red
                } else {
                    items[0].badgeValue = nil
                    items[0].badgeColor = nil
                }
            } else {
                items[1].badgeValue = nil
                items[1].badgeColor = nil
                let adad = (res.messageUnReadCount ?? 0) + (res.ticketUnReadCount ?? 0)
                if (res.messageUnReadCount ?? 0) > 0 {
                    self.postchiCountView.alpha = 1
                    self.postchiCountLabel.text = "\(res.messageUnReadCount ?? 0)"
                } else {
                    self.postchiCountView.alpha = 0
                }
                if (res.ticketUnReadCount ?? 0) > 0 {
                    self.ticketCountLabel.text = "\(res.ticketUnReadCount ?? 0)"
                    self.ticketCountView.alpha = 1
                } else {
                    self.ticketCountView.alpha = 0
                }
                if adad > 0 {
                    items[0].badgeValue = "\(adad)"
                    items[0].badgeColor = .red
                } else {
                    items[0].badgeValue = nil
                    items[0].badgeColor = nil
                }
            }
        }
    }
    
    func fetchNotifi() {
        // MARK: - Notif
        RestfulAPI<EMPTYMODEL,Notif>.init(path: "/User/notification")
            .with(method: .GET)
            .with(auth: .user)
            .sendURLSessionRequest { result in
                DispatchQueue.main.async {
                    if case .success(let res) = result {
                        DataManager.shared.notif = res
                        self.updateNotifUI(res: res)
                    }
                }
            }
    }
    
    func updateUI() {
        if Authentication.user.isLogin {
            loginButton.setTitle("خروج", for: .normal)
            
            if let mobile = DataManager.shared.userProfile?.data?.userName {
                titleLabel.text = "شما با شماره \(mobile) وارد شده اید و آگهی های ثبت شده با این شماره را مشاهده میکنید"
            }
            self.tableView.reloadData()
        } else {
            loginButton.setTitle("ورود", for: .normal)
            titleLabel.text = "برای استفاده از تمام امکانات ملکیتا مانند ثبت و مدیریت آگهی و گفتگو وارد حساب کاربری شوید."
        }
    }
    
    @IBAction func unwindToProfileVC(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func buttonTapped() {
        if Authentication.user.isLogin {
            self.presentCDAlertWarningWithTwoAction(message: "آیا میخواهید از پروفایل کاربری خود خارج شوید؟", buttonOneTitle: "بله", buttonTwoTitle: "خیر") {
                self.performSegue(withIdentifier: "toLoaderVC", sender: nil)
                var user = Authentication.user
                user
                    .logout()
                DataManager.shared.refreshToken = nil
                DataManager.shared.userProfile = nil
                DataManager.shared.userInfo = nil
                DataManager.shared.documentStatus = nil
                DataManager.shared.role = nil
                
            } handlerButtonTwo: {
                // kheyr
            }

        } else {
            self.performSegue(withIdentifier: "toLoginVC", sender: nil)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let role = DataManager.shared.role {
            if role == .Marketer {
                return 5
            } else {
                return 5
            }
        } else {
           return 5
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        // login buttons.
        if section == 1 {
            if DataManager.shared.auth.isLogin {
                if let role = DataManager.shared.role {
                    switch role {
                    case .User, .EstateAdvisor,.Admin, .SuperAdmin:
                        if DataManager.shared.isApproveDocument {
                            return 8
                        } else {
                            return 9 // ezafe shodan list madarek be profile.
                        }
                    case .Marketer:
                        if DataManager.shared.isApproveDocument {
                            return 8 // SAMPLE
                        } else {
                            return 9 //SAMPLE: ezafe shodan list madarek be profile.
                        }
                    }
                } else {
                    return 8
                }
            } else {
                return 0
            }
        }
        
        if section == 2 {
            if let role = DataManager.shared.role {
                if case .Marketer = role {
                    return 1
                } else {
                    return 0
                }
            } else {
                return 0
            }
        }
        
        if section == 3 {
//            if DataManager.shared.auth.isLogin {
//                if let role = DataManager.shared.role {
//                    switch role {
//                    case .Admin:
//                        break
//                    case .User, .EstateAdvisor:
//                            return 1
//                    case .Marketer:
//                        return 1
//                    }
//                }
//            }
            return 1
        }
                
        // login profiles items.
        if section == 4 {
            if isEnableContract {
                return 3
            } else {
                return 4
            }
        }
        
        // global items.
        return 0
    }
    
    func open(urlSting: String) {
        guard let botURL = URL.init(string: urlSting) else {
            return
        }
        if UIApplication.shared.canOpenURL(botURL) {
            UIApplication.shared.openURL(botURL)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Authentication.user.isLogin {
            if indexPath.section == 1 {
                switch indexPath.item {
                case 0: // dashboard avalin cell
                    break
                case 5:
                    let vc = PostchiTableViewController.create()
                    show(vc, sender: nil)
                    break
                case 6:
                    let vc = BazdidAkhirTableViewController.create()
                    show(vc, sender: nil)
                    break
                case 7:
                    let vc = MainTicketTableViewController.create()
                    show(vc, sender: nil)
                    break
                case 8:
                    let vc = ErsalMadarekTableViewController.create()
                    show(vc, sender: nil)
                    break
                default:
                    break
                }
            }
        }
        
        if indexPath.section == 3 {
            open(urlSting: "https:www.melkita.com/chat")
        }
        
        if indexPath.section == 2 {
            let vc = BazaryabMainTableViewController.create()
            show(vc, sender: nil)
        }
        
        if indexPath.section == 4 {
            if indexPath.item == 0 {
                open(urlSting: "https://www.melkita.com/contactus")
            }
            if indexPath.item == 1 {
                let vc = MelkitaAddvertiseTableViewController.create()
                show(vc, sender: nil)
            }
            if indexPath.item == 3 {
                open(urlSting: "https://contract.melkita.com")
            }
        }
    }
}

/*
 new Role{Name="SuperAdmin",IsMain = true,Description = "مدیر ارشد"},
                 new Role{Name="Admin",IsMain = true,Description= "کارمند"},
                 new Role{Name="User",IsMain = true,Description = "مشتری"},
                 new Role{Name = "Marketer",IsMain = true, Description = "بازاریاب"},
                 new Role{Name="EstateAdvisor",IsMain = true, Description = "مشاور املاک"}
 */

enum RoleEnum: String {
    case Admin
    case SuperAdmin
    case User
    case Marketer
    case EstateAdvisor
}

/*
 case 8:
     break
 */

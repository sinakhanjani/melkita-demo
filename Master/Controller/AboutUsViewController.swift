//
//  AboutUsViewController.swift
//  Master
//
//  Created by Sina khanjani on 2/31/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit

class AboutUsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let roleEnum:RoleEnum = DataManager.shared.role ?? .Admin
        var type = 0
        switch roleEnum {
        case .Admin, .SuperAdmin:
            type = 0
        case .User:
            type = 3
        case .Marketer:
            type = 1
        case .EstateAdvisor:
            type = 2
        }
        
        switch indexPath.item {
        case 0:
            open(urlSting: "https://www.melkita.com/policy")
            break
        case 1:
            open(urlSting: "https://www.melkita.com/term")
            break
        case 2:
            open(urlSting: "https://www.melkita.com/aboutus")
            break
        case 3:
            open(urlSting: "https://www.melkita.com/faq")
            break
        case 4:
            open(urlSting: "https://www.melkita.com/mag/Legal")
            break
        case 5:
            open(urlSting: "https://www.melkita.com/work-with-us")
            break
        case 6:
            open(urlSting: "https://www.melkita.com/form?type=\(type)")
            break
        case 7:
            open(urlSting: "https://www.melkita.com/training")
            break
        default:
            break
        }
    }
    
    func open(urlSting: String) {
        guard let botURL = URL.init(string: urlSting) else {
            return
        }
        if UIApplication.shared.canOpenURL(botURL) {
            UIApplication.shared.open(botURL)
        }
    }
}

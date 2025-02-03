//
//  AgahiDetailPersonTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 4/25/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit

class AgahiDetailPersonTableViewController: UITableViewController {
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var familyLabel: UILabel!
    @IBOutlet weak var nameLAbel: UILabel!
    
    var rcPayment: RCPaymentModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        phoneLabel.text = rcPayment?.phoneNumber
        familyLabel.text = rcPayment?.lastName
        nameLAbel.text = rcPayment?.name
        tableView.tableFooterView = UIView()
    }

    @IBAction func callButtonTapped(_ sender: Any) {
        rcPayment?.phoneNumber?.makeACall()
    }
}

//
//  PopoeverViewController.swift
//  Master
//
//  Created by Sina khanjani on 6/16/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    
    var subject: String?
    var infromation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let subject = subject, let infromation = infromation {
            self.subjectLabel.text = subject
            self.informationLabel.text = infromation
        }
    }
    
    
}

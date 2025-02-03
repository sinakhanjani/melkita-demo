//
//  HintViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/26/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit

class HintViewController: UIViewController {
    
    var text:String?

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.font = UIFont.persianFont(size: 17)
        textView.text = text
    }
}

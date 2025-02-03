//
//  PaymentWebViewController.swift
//  Master
//
//  Created by Sina khanjani on 7/18/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import WebKit

class PaymentWebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var str: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let str = str, let url = URL(string: str) {
            
            print("STR", str)
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

}

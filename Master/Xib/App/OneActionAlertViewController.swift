//
//  OneActionAlertViewController.swift
//  Master
//
//  Created by Sinakhanjani on 4/22/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

class OneActionAlertViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    private var subtitle: String?
    private var detail: String?
    private var completionHandler: (() -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTouchXibByPresentViewController(bgView: view)
        if let subtitle = subtitle, let detail = detail {
            self.subtitleLabel.text = subtitle
            self.detailLabel.text = detail
        }
    }

    @IBAction func doneButtonTapped(_ sender: RoundedButton) {
        dismiss(animated: false) { () -> Void in
            self.completionHandler?()
        }
    }
    
    static func create(viewController: UIViewController, title: String?, subtitle: String?, completionHandler: (() -> Void)?) {
        let vc = OneActionAlertViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.subtitle = title
        vc.detail = subtitle
        vc.completionHandler = completionHandler
        viewController.view.endEditing(true)
        viewController.present(vc, animated: true, completion: nil)
    }
    

}


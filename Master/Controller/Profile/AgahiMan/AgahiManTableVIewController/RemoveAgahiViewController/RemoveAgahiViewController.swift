//
//  RemoveAgahiViewController.swift
//  Master
//
//  Created by Sina khanjani on 6/30/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

protocol RemoveAgahiViewControllerDelegate {
    func doneRemove()
}

class RemoveAgahiViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!

    let items = [
        "منصرف شدن از فروش",
                 "از روش دیگری فروخته شد",
                 "از طریق ملکیتا فروخته شد یا اجاره دادم",
                 "از خدمات ملکیتا راضی نبودم",
                 "از خدمات ملکیتا راضی بودم",
                 ]
    
    var id: String?
    var selectedIndex = 0
    var delegate:RemoveAgahiViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let touch = UITapGestureRecognizer(target: self, action: #selector(tapped))
        bgView.addGestureRecognizer(touch)
    }
    
    @objc func tapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func agreeButtonTapped() {
        guard let id = id else {
            return
        }
        struct Send: Codable {
            let id: String
            let reasonForDeleted: String
        }
        RestfulAPI<Send,GenericOrginal<EMPTYMODEL>>.init(path: "/Estate")
        .with(auth: .user)
        .with(method: .DELETE)
            .with(body: Send(id: id, reasonForDeleted: items[selectedIndex]))
            .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                self.stopIndicatorAnimate()
                switch result {
                case .success(let res):
                    self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {
                        self.delegate?.doneRemove()
                        self.dismiss(animated: true, completion: nil)
                    })
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    @IBAction func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = UIFont.persianFont(size: 17)
        label.textColor = .black
        label.textAlignment = .center
        label.text = items[row]
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedIndex = row
    }
}

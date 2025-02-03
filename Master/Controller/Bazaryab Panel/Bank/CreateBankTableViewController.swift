//
//  CreateBankTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/24/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class CreateBankTableViewController: UITableViewController {

    var item: BankCardElement?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var familyTextField: UITextField!
    @IBOutlet weak var shabaTextField: UITextField!
    @IBOutlet weak var cardTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.shabaTextField.keyboardType = .asciiCapableNumberPad
        self.cardTextField.keyboardType = .asciiCapableNumberPad
        self.nameTextField.keyboardType = .default
        self.familyTextField.keyboardType = .default

        backBarButtonAttribute(color: .black, name: "")
        title = "افزودن کارت بانکی"
        if let item = item {
            self.nameTextField.text = item.firstName
            self.familyTextField.text = item.lastName
            self.shabaTextField.text = item.shaba
            if self.shabaTextField.text!.lowercased().contains("ir") {
                self.shabaTextField.text!.removeFirst()
                self.shabaTextField.text!.removeFirst()
            }
            self.cardTextField.text = item.cardNumber
        }
    }
    
    
    func addReq() {
        // MARK: - SinglePackage
        struct Send: Codable {
            let firstName, lastName, shaba, cardNumber: String
        }

        RestfulAPI<Send,GenericOrginal<EMPTYMODEL>>.init(path: "/BankCard")
        .with(auth: .user)
        .with(method: .POST)
            .with(body: Send(firstName: self.nameTextField.text!, lastName: self.familyTextField.text!, shaba: self.shabaTextField.text!, cardNumber: cardTextField.text!))
        .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let res):
                    self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                    if res.isSuccess == true {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    func editReq() {
        guard let id = self.item?.id else { return }
        // MARK: - SinglePackage
        struct Send: Codable {
            let firstName, lastName, shaba, cardNumber, id: String
        }

        RestfulAPI<Send,GenericOrginal<EMPTYMODEL>>.init(path: "/BankCard")
        .with(auth: .user)
        .with(method: .PUT)
            .with(body: Send(firstName: self.nameTextField.text!, lastName: self.familyTextField.text!, shaba: self.shabaTextField.text!, cardNumber: cardTextField.text!, id: id))
        .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let res):
                    self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                    if res.isSuccess == true {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    @IBAction func saveButtontapped() {
        guard !self.nameTextField.text!.isEmpty,!self.familyTextField.text!.isEmpty,!self.shabaTextField.text!.isEmpty,!self.cardTextField.text!.isEmpty else {
            self.presentCDAlertWarningAlert(message: "لطفا تمامی فیلدها را تکمیل نمایید", completion: {})
            return
        }
        view.endEditing(true)
        if self.shabaTextField.text!.lowercased().contains("ir") {
            self.shabaTextField.text!.removeFirst()
            self.shabaTextField.text!.removeFirst()
        }
        if item == nil {
            // new
            addReq()
        } else {
            // edit
            editReq()
        }
    }
}

//
//  TasviehTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/23/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class TasviehTableViewController: UITableViewController, SelectionTableViewControllerDelegate {
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var noeVariziLabel: UILabel!
    @IBOutlet weak var bankCardLabel: UILabel!
    @IBOutlet weak var minVarizLabel: UILabel!

    var isBankcardsEmpty = true
    var banks = [BankCardElement]()
    
    var validsCards = [BankCardElement]()
    
    var noeVariz: SelectionModel? {
        willSet {
            self.noeVariziLabel.text = newValue?.title
            if newValue?.id == DepositTypeEnum.Wallet.value {
                self.bankCard = nil
            }
        }
    }
    
    var bankCard: SelectionModel? {
        willSet {
            if let title = newValue?.title {
                self.bankCardLabel.text = title
            }
            }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .black, name: "")
        title = "تسویه حساب"
        fetchBanks()
        
        if let min = DataManager.shared.setting?.minClearingMarketer {
            self.minVarizLabel.text = "حداقل مبلغ برای تسویه \(min.seperateByCama) تومان است"
        }
    }
    
    func fetchBanks() {
        RestfulAPI<Empty,[BankCardElement]>.init(path: "/BankCard")
        .with(auth: .user)
        .with(method: .GET)
        .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let res):
                    self.banks = res
                    self.validsCards = res.filter { $0.status == 1 }
                    self.isBankcardsEmpty = self.validsCards.isEmpty
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    func clearBank(price: Int, type: Int, bankCardID: String?) {
        // MARK: - ClearBank
        struct ClearBank: Codable {
            let credit: Int?
            let type, bankCardID: String?

            enum CodingKeys: String, CodingKey {
                case credit, type
                case bankCardID = "bankCardId"
            }
        }
        let body = ClearBank(credit: price, type: String(type), bankCardID: bankCardID)
        RestfulAPI<ClearBank,GenericOrginal<EMPTYMODEL>>.init(path: "/Marketer/clear-credit")
        .with(auth: .user)
        .with(method: .POST)
            .with(body: body)
        .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let res):
                    if res.isSuccess == true {
                        self.performSegue(withIdentifier: "tasviehToProfielSegue", sender: nil)
                        self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                    }
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if noeVariz?.id == DepositTypeEnum.Card.value { // banki
            return 4
        }
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 1
        }
        if section == 1 {
            return 2
        }
        if section == 2 {
            if noeVariz?.id == DepositTypeEnum.Card.value {
                return 2 // bank
            } else {
                return 1
            }
        }
        if section == 3 {
            return 1
        }
        
        return 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.item == 0 {
                let vc = SelectionTableViewController.create()
                vc.delegate = self
                let items =  DepositTypeEnum.allCases.map { SelectionModel(id: "\($0.rawValue)", title: $0.name(), section: .city) }
                vc.selectionModels = items
                show(vc, sender: nil)
            }
            if indexPath.item == 1 {
                // banks
                let vc = SelectionTableViewController.create()
                vc.delegate = self
                vc.selectionModels = self.validsCards.map { SelectionModel(id: $0.id ?? "", title: $0.cardNumber ?? "", section: .city) }
                show(vc, sender: nil)
            }
        }

    }
    
    func didselectSection(item: SelectionModel) {
        if let indexPath = tableView.indexPathForSelectedRow {
            if indexPath.section == 2 {
                if indexPath.item == 0 {
                    self.noeVariz = item
                    self.tableView.reloadData()
                }
                if indexPath.item == 1 {
                    // entekhab card bank
                    self.bankCard = item
                }
            }
        }
    }
    
    @IBAction func saveButtonTapped() {
        guard let idStr = noeVariz?.id, let intId = Int(idStr) else {
            presentCDAlertWarningAlert(message: "لطفا نوع واریز را تعیین کنید", completion: {})
            return
        }
        guard let price = Int(self.priceTextField.text!), price > 0 else {
            presentCDAlertWarningAlert(message: "لطفا مبلغ را به درستی وارد کنید", completion: {})
            return
        }

        if intId == DepositTypeEnum.Card.rawValue {
            // card banki
            if !self.isBankcardsEmpty {
                if let bankCardID = self.bankCard?.id {
                    self.clearBank(price: price, type: intId, bankCardID: bankCardID)
                } else {
                    presentCDAlertWarningAlert(message: "لطفا کارت اعتباری خود را انتخاب کنید", completion: {})
                }
            } else {
                presentCDAlertWarningAlert(message: "کارت اعتباری برای شما ثبت یا تایید نشده است", completion: {})
            }
            return
        }
        
        if intId == DepositTypeEnum.Wallet.rawValue {
            // walet
            self.clearBank(price: price, type: intId, bankCardID: nil)
            return
        }
    }
}

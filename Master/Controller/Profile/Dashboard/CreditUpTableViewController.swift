//
//  CreditUpTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/10/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class CreditUpTableViewController: UITableViewController {
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var dargahLabel: UILabel!
    @IBOutlet weak var priceDetailLabel: UILabel!
    
    var banks: [RCBankModelElement] = []
    var selectedBank: SelectionModel? {
        willSet {
            dargahLabel.text = newValue?.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "افزاریش موجودی"
        getBankRequest()
        backBarButtonAttribute(color: .black, name: "")
        if let min = DataManager.shared.setting?.minIncInventory {
            self.priceDetailLabel.text = "حداقل مبلغ برای افزایش موجودی کیف پول \(min.seperateByCama) تومان میابشد"
        }
    }
    
    func getBankRequest() {
        RestfulAPI<Empty,[RCBankModelElement]>.init(path: "/Common/payment-gateway")
            .with(auth: .user)
            .with(method: .GET)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.banks = res
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
    }
    
    func sendbankReq(price: Int) {
        guard let bankID = self.selectedBank?.id else {
            presentCDAlertWarningAlert(message: "درگاه بانکی را انتخاب کنید", completion: {})
            return
        }
        // MARK: - RSBank
        struct RSBank: Codable {
            let inventory, gate: Int
        }
        
        struct RCBank: Codable {
            let token: String?
            let urlPay: String?
            let refId: String?
            let isMellat: Bool?
            let isSepehr: Bool?
            let mobile: String?
            let siteUrl: String
        }

        RestfulAPI<RSBank,GenericOrginal<RCBank>>.init(path: "/Wallet/inc-inventory")
            .with(auth: .user)
            .with(method: .POST)
            .with(body: RSBank(inventory: price, gate: Int(bankID)!))
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        var queries: [String:String] = [:]
                        if let item = res.data?.token {
                            queries.updateValue(item, forKey: "token")
                        }
                        if let item = res.data?.refId {
                            queries.updateValue(item, forKey: "refId")
                        }
                        if let item = res.data?.isMellat {
                            queries.updateValue(String(describing: item), forKey: "isMellat")
                        }
                        if let item = res.data?.isSepehr {
                            queries.updateValue(String(describing: item), forKey: "isSepehr")
                        }
                        if let item = res.data?.mobile {
                            queries.updateValue(item, forKey: "mobile")
                        }
                        if let url = res.data?.siteUrl {
                            self.openGatewayURL(query: queries, siteURL: url)
                        }
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
    }
    
    func openGatewayURL(query: [String:String],siteURL:String) {
        if let url = URL(string: "https://melkita.com\(siteURL)"), let urlWithQuery = url.withQuries(query), UIApplication.shared.canOpenURL(urlWithQuery) {
            print("bank URL: ",urlWithQuery)
            if #available(iOS 10, *) {
                UIApplication.shared.open(urlWithQuery)
            } else {
                UIApplication.shared.openURL(urlWithQuery)
            }
        }
        performSegue(withIdentifier: "unwindCreditUpToProfileSegue", sender: nil)
    }
    
    @IBAction func payButtonTapped() {
        guard let price = Int(priceTextField.text!), price > 0 else {
            presentCDAlertWarningAlert(message: "لطفا مبلغ را وارد کنید", completion: {})
            return
        }
        sendbankReq(price: price)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let vc = SelectionTableViewController.create()
            let selections = banks.map { SelectionModel(id: "\($0.key)", title: $0.title, section: .estayeBaseType) }
            vc.selectionModels = selections
            vc.delegate = self
            show(vc, sender: nil)
        }
    }
    
}

extension CreditUpTableViewController: SelectionTableViewControllerDelegate {
    func didselectSection(item: SelectionModel) {
        self.selectedBank = item

    }
}

/*
 public class PayIncInventoryDto
     {
         public string Token { get; set; }
       
         public string UrlPay { get; set; }
        
         public string RefId { get; set; }
         public bool IsMellat { get; set; }
         public bool IsSepehr { get; set; }
         public string Mobile { get; set; }
         public string SiteUrl { get; set; }
     }
 */
// ---------- ------------ ------------- ------------
/*
 PayIncInventoryDto {
 RefId
 IsMellat
 IsSepehr
 Mobile
 Token
 }
 
 SiteUrl = "/IncInventory?"
 */

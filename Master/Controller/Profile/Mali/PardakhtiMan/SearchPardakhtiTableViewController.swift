//
//  SearchPardakhtiTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

protocol SearchPardakhtiTableViewControllerDelegate {
    func addSearchQuery(_ dict: [String: String])
}

class SearchPardakhtiTableViewController: UITableViewController {
    
    @IBOutlet weak var discountPackageLabel: UILabel!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var codePeygiriTextField: InsetTextField!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var onlyMobileSwitch: UISwitch!
    @IBOutlet weak var onlyWalletSwitch: UISwitch!
    
    var delegate: SearchPardakhtiTableViewControllerDelegate?

    var queries: [String: String] = ["IsWallet":String(describing: false),
                                     "IsMobile":String(describing: false)]
    var rcPackageItems: [RCPackageItem] = []
    var discountPackage: SelectionModel? {
        willSet {
            discountPackageLabel.text = newValue?.title
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        onlyMobileSwitch.isOn = false
        onlyWalletSwitch.isOn = false
        title = "جستجو در پرداختی‌های من"
        backBarButtonAttribute(color: .black, name: "")
        toDatePicker.calendar = Calendar(identifier: .persian)
        toDatePicker.locale = Locale(identifier: "fa_ir")
        
        fromDatePicker.calendar = Calendar(identifier: .persian)
        fromDatePicker.locale = Locale(identifier: "fa_ir")
        fetchPackage()
    }
    
    func fetchPackage() {
        RestfulAPI<Empty,[RCPackageItem]>.init(path: "/DiscountPackage/use-pay")
        .with(auth: .user)
        .with(method: .GET)
        .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                self.stopIndicatorAnimate()
                switch result {
                case .success(let res):
                    self.rcPackageItems = res
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    @IBAction func onlyMobileValueChanged(_ sender: UISwitch) {
        queries["IsMobile"] = String(describing: sender.isOn)
    }
    
    @IBAction func onlyWalletValueChanged(_ sender: UISwitch) {
        queries["IsWallet"] = String(describing: sender.isOn)
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        if let text = codePeygiriTextField.text, !text.isEmpty {
            queries.updateValue(text, forKey: "TrackingCode")
        }
        let fromDate = fromDatePicker.date.englishDate()
        let toDate = toDatePicker.date.englishDate()
        queries.updateValue(toDate, forKey: "MaxDate")
        queries.updateValue(fromDate, forKey: "MinDate")
        if let packageID = discountPackage?.id {
            queries.updateValue(packageID, forKey: "DiscountPackageUserId")
        }
        delegate?.addSearchQuery(queries)
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let vc = SelectionTableViewController.create()
            let selections = rcPackageItems.map { SelectionModel(id: $0.id ?? "", title: $0.title ?? "", section: .estayeBaseType) }
            vc.selectionModels = selections
            vc.delegate = self
            show(vc, sender: nil)
        }
    }
}

extension SearchPardakhtiTableViewController: SelectionTableViewControllerDelegate {
    func didselectSection(item: SelectionModel) {
        self.discountPackage = item
    }
}

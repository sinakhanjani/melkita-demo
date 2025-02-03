//
//  FilterArchiveVariziTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/24/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit

protocol FilterArchiveVariziTableViewControllerDelegate {
    func searchDone(query: [String:String])
}
class FilterArchiveVariziTableViewController: UITableViewController {

    @IBOutlet weak var nieVarizLabel: UILabel!
    @IBOutlet weak var toDate: UIDatePicker!
    @IBOutlet weak var vaziyatLabel: UILabel!
    @IBOutlet weak var fromDate: UIDatePicker!
    @IBOutlet weak var shenaseTextField: InsetTextField!
    
    var queries = [String:String]()
    
    var noeVariz: SelectionModel? {
        willSet {
            self.nieVarizLabel.text = newValue?.title
        }
    }
    
    var currentPickerDate = Date()
    
    var vaziyatVariz: SelectionModel? {
        willSet {
            self.vaziyatLabel.text = newValue?.title
        }
    }
    
    var delegate:FilterArchiveVariziTableViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .black, name: "")
        title = "جستجو آرشیو واریزی"
    
        currentPickerDate = toDate.date
        toDate.calendar = Calendar(identifier: .persian)
        toDate.locale = Locale(identifier: "fa_ir")
        
        fromDate.calendar = Calendar(identifier: .persian)
        fromDate.locale = Locale(identifier: "fa_ir")
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        let fromDateStr = fromDate.date.englishDate()
        let toDateStr = toDate.date.englishDate()
        if toDate.date != currentPickerDate {
            queries.updateValue(toDateStr, forKey: "MaxDate")

        }
        if toDate.date != currentPickerDate {
            queries.updateValue(fromDateStr, forKey: "MinDate")
        }
        
        if !shenaseTextField.text!.isEmpty {
            queries.updateValue(shenaseTextField.text!, forKey: "Code")
        }
        if let type = self.noeVariz?.id {
            queries.updateValue(type, forKey: "Type")
        }
        if let status = self.vaziyatVariz?.id {
            queries.updateValue(status, forKey: "Status")
        }
        
        delegate?.searchDone(query: queries)
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            // vaziyat
            let vc = SelectionTableViewController.create()
            vc.selectionModels = DepositStatusEnum.allCases.map { SelectionModel(id: "\($0.rawValue)", title: $0.name(), section: .city) }
            vc.delegate = self
            show(vc, sender: nil)
        }
        if indexPath.section == 4 {
            // noe variz
            let vc = SelectionTableViewController.create()
            vc.selectionModels = DepositTypeEnum.allCases.map { SelectionModel(id: "\($0.rawValue)", title: $0.name(), section: .city) }
            vc.delegate = self
            show(vc, sender: nil)
        }
    }
}

extension FilterArchiveVariziTableViewController: SelectionTableViewControllerDelegate {
    func didselectSection(item: SelectionModel) {
        if let indexPath = tableView.indexPathForSelectedRow {
                if indexPath.section == 3 {
                    self.noeVariz = item
                }
                if indexPath.section == 4 {
                    self.vaziyatVariz = item
                }
        }
    }
}

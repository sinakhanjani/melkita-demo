//
//  SearchAgahiManTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/10/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit

protocol SearchAgahiManTableViewControllerDelegate {
    func searchDone(_ query: [String: String])
}

class SearchAgahiManTableViewController: UITableViewController {

    @IBOutlet weak var noeAgahiLabel:UILabel!
    @IBOutlet weak var searchTextField:UITextField!

    var delegate: SearchAgahiManTableViewControllerDelegate?
    var selectionModel: SelectionModel? {
        willSet {
            self.noeAgahiLabel.text = newValue?.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "جستجو در آگهی من"
        backBarButtonAttribute(color: .black, name: "")
        searchTextField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = SelectionTableViewController.create()
            let estayeBaseTypeModels = [SelectionModel(id: "1", title: "خرید و فروش", section: .estayeBaseType),SelectionModel(id: "2", title: "رهن و اجاره", section: .estayeBaseType),SelectionModel(id: "0", title: "هر دو", section: .estayeBaseType)]
            vc.selectionModels = estayeBaseTypeModels
            vc.delegate = self
            navigationController?.show(vc, sender: nil)
        }
    }
    
    @IBAction func doneButtonTapped() {
        guard searchTextField.text!.isEmpty == false else {
            presentCDAlertWarningAlert(message: "لطفا عبارت خود را وارد کنید", completion: {})
            return
        }
        guard let noeAgahi = self.selectionModel?.id else {
            presentCDAlertWarningAlert(message: "نوع آگهی را انتخاب کنید", completion: {})
            return
        }
        let query = ["Key":searchTextField.text!,
                     "Type":noeAgahi]
        delegate?.searchDone(query)
        navigationController?.popViewController(animated: true)
    }
}

extension SearchAgahiManTableViewController: SelectionTableViewControllerDelegate {
    func didselectSection(item: SelectionModel) {
        if let indexPath = tableView.indexPathForSelectedRow {
            if indexPath.section == 0 {
                self.selectionModel = item
            }
        }
    }
}

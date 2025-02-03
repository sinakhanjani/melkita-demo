//
//  AddAgahiStep4TableViewController.swift
//  Master
//
//  Created by Sina khanjani on 4/26/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit

struct CheckBoxItem: Hashable {
    let title: String
    let state: Bool
}

struct TextFieldModel: Hashable {
    let id: Int
    let title: String
}

struct OriginModel: Hashable {
    internal init(id: Int, title: String, placeHolder: String, state: Bool) {
        self.id = id
        self.title = title
        self.placeHolder = placeHolder
        self.price = nil
        self.state = state
    }
    
    let id: Int
    let title: String
    let placeHolder: String
    let price: Int?
    let state: Bool
}

class AddAgahiStep4TableViewController: UITableViewController {
    
    enum Section {
        case otaq
        case rahnKamel
        case rahn
        case ejare
        case feature
        case condition
        case forosh
    }
    
    enum AgahiRow4: Hashable {
        case otaq(SelectionModel?)
        case origin(OriginModel)
        case checkBox(CheckBoxItem)
        case dynamicCheckboxFeature(Feature)
        case dynamicCheckboxCondition(Condition)
    }

    private var tableViewDataSource: UITableViewDiffableDataSource<Section,AgahiRow4>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, AgahiRow4>()
    
    var addAgahi = AddAgahiModelBody()
    var addInfo: AddInfo?
    
    var featureIds: [String] = []
    var conditionIds: [String] = []
    
    var isUpdate = false
    var updateEstateID: String?
    var agahiModel: AgahiModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .black, name: "")
        title = "ثبت آگهی"
        //
        addAgahi.countRoom = 0
        if isUpdate {
            addAgahi.countRoom = agahiModel?.countRoom
            addAgahi.isAgreementPriceBuy = agahiModel?.isAgreementPriceBuy
            addAgahi.isMortgage = agahiModel?.isMortgage
            addAgahi.isAgreementPriceRent = agahiModel?.isAgreementPriceRent
            addAgahi.isAgreementPriceMortgage = agahiModel?.isAgreementPriceMortgage
            addAgahi.priceBuy = agahiModel?.priceBuy
            addAgahi.priceRent = agahiModel?.priceRent
            addAgahi.priceMortgage = agahiModel?.priceMortgage
            if let conditions = agahiModel?.conditions {
                let ids = conditions.map { $0.condition!.id! }
                self.conditionIds = ids
                if addInfo?.conditions != nil {
                    for (index,item) in addInfo!.conditions!.enumerated() {
                        if conditionIds.contains(item.id) {
                            addInfo?.conditions?[index].isCheck = true
                        }
                    }
                }
            }
            if let features = agahiModel?.features {
                let ids = features.map { $0.feature!.id! }
                self.featureIds = ids
                if addInfo?.features != nil {
                    for (index,item) in addInfo!.features!.enumerated() {
                        if featureIds.contains(item.id) {
                            addInfo?.features?[index].isCheck = true
                        }
                    }
                }
            }
        }
        perform()
    }
    
    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section,AgahiRow4> {
        var snapshot = NSDiffableDataSourceSnapshot<Section,AgahiRow4>()
        
        snapshot.appendSections([.otaq])
        let otaq = addAgahi.countRoom ?? 0
        let title = (otaq != 0)  ? "\(otaq) اتاق": "بدون اتاق"
        let item: AgahiRow4 = .otaq(SelectionModel(id: "\(otaq)", title: title , section: .room))
        snapshot.appendItems([item], toSection: .otaq)
        
        if let type = addAgahi.type {
            if type == 1 {
                // kharid forosh
                snapshot.appendSections([.forosh])
                let model = OriginModel(id: 0, title: "فـروش", placeHolder: "قیمت فروش به تومان", state: addAgahi.isAgreementPriceBuy ?? false)
                let item = AgahiRow4.origin(model)

                snapshot.appendItems([item], toSection: .forosh)
            }
            if type == 2 {
                // rah ejrae
                snapshot.appendSections([.rahnKamel, .rahn, .ejare])
                
                let rahnKamel = AgahiRow4.checkBox(CheckBoxItem(title: "رهن کامل", state: addAgahi.isMortgage ?? false))
                snapshot.appendItems([rahnKamel], toSection: .rahnKamel)
                
                let rahnItem = OriginModel(id: 1, title: "رهـن", placeHolder: "قیمت رهن به تومان", state: addAgahi.isAgreementPriceMortgage ?? false)
                let rahn = AgahiRow4.origin(rahnItem)
                snapshot.appendItems([rahn], toSection: .rahn)
                
                if (addAgahi.isMortgage ?? false) {
                    // agar rahn kamel bod
                    addAgahi.priceRent = 0
                    addAgahi.isAgreementPriceRent = false
                } else {
                    // agar rahn kamel nabod
                    let ejare = AgahiRow4.origin(OriginModel(id: 2, title: "اجاره", placeHolder: "قیمت اجاره به تومان", state: addAgahi.isAgreementPriceRent ?? false))
                    snapshot.appendItems([ejare], toSection: .ejare)
                }
            }
            
            if let feature = addInfo?.features {
                let converted = feature.map { AgahiRow4.dynamicCheckboxFeature($0)}
                snapshot.appendSections([.feature])
                snapshot.appendItems(converted, toSection: .feature)
            }
            
            if let condtions = addInfo?.conditions {
                let converted = condtions.map { AgahiRow4.dynamicCheckboxCondition($0)}
                snapshot.appendSections([.condition])
                snapshot.appendItems(converted, toSection: .condition)
            }
        }
        
        return snapshot
    }
    
    private func perform() {
        tableViewDataSource = .init(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            switch item {
            case .checkBox(let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.identifier) as! CheckBoxTableViewCell
                // faqat rahn kamel
                cell.titleLabel.text = item.title
                cell.checkBox.isChecked = item.state
                cell.checkBox.valueChanged = { state in
                    self.addAgahi.isMortgage = state
                    self.reload()
                }

                return cell
            case .dynamicCheckboxFeature(let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.identifier) as! CheckBoxTableViewCell
                cell.titleLabel.text = item.title
                cell.checkBox.isChecked = item.isCheck ?? false
                cell.checkBox.valueChanged = { status in
                    if let items = self.addInfo?.features {
                        self.addInfo?.features?[indexPath.row].isCheck = status
                        
                        let item = items[indexPath.row]

                        let index = self.featureIds.lastIndex { (i) -> Bool in
                            return i == item.id
                        }
                        
                        if let index = index {
                            self.featureIds.remove(at: index)
                        } else {
                            self.featureIds.append(item.id)
                        }
                    }
                    self.reload()
                }

                return cell
            case .dynamicCheckboxCondition(let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.identifier) as! CheckBoxTableViewCell
                cell.titleLabel.text = item.title
                cell.checkBox.isChecked = item.isCheck ?? false
                cell.checkBox.valueChanged = { status in
                    self.addInfo?.conditions?[indexPath.row].isCheck = status

                    if let item = self.addInfo?.conditions?[indexPath.row] {
                        let index = self.conditionIds.lastIndex { (i) -> Bool in
                            return i == item.id
                        }
                        if let index = index {
                            self.conditionIds.remove(at: index)
                        } else {
                            self.conditionIds.append(item.id)
                        }
                    }
                    self.reload()
                }

                return cell
            case .otaq(let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: "selection")!
                cell.textLabel?.text = item?.title ?? "انتخاب کنید"
                cell.accessoryType = .disclosureIndicator
                
                return cell
            case .origin(let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: OriginModelTableViewCell.identifier) as! OriginModelTableViewCell
                cell.delegate = self
                cell.titleLabel?.text = "توافقی"
                if let price = item.price {
                    cell.nameTextField.text = "\(price)"
                }
                cell.nameTextField.placeholder = item.placeHolder
                cell.checkBox.isChecked = item.state
                cell.nameTextField.isEnabled = item.state ? false:true
                cell.nameTextField.text = item.state ? nil: cell.nameTextField.text
                cell.nameTextField.backgroundColor = item.state ? .darkGray:.clear
                cell.checkBox.isChecked = item.state
                
                cell.checkBox.valueChanged = { status in
                    if item.id == 0 {
                        // forosh
                        self.addAgahi.isAgreementPriceBuy = status
                        if status {
                            self.addAgahi.priceBuy = 0
                            cell.nameTextField.text = nil
                        }
                    }
                    if item.id == 1 {
                        //rahn
                        self.addAgahi.isAgreementPriceMortgage = status
                        if status {
                            self.addAgahi.priceMortgage = 0
                            cell.nameTextField.text = nil
                        }
                    }
                    
                    if item.id == 2 {
                        // ejare
                        self.addAgahi.isAgreementPriceRent = status
                        if status {
                            self.addAgahi.priceRent = 0
                            cell.nameTextField.text = nil
                        }
                    }
                    
                    self.reload()
                }
                
                return cell
            }
        }
        
        reload()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont.persianFont(size: 17)
        label.textAlignment = .right
        label.textColor = .black
        
        let item = snapshot.sectionIdentifiers[section]
        label.text = ""
        
        switch item {
        case .otaq:
            label.text = "تعداد اتاق خواب"
        case .rahnKamel:
            label.text = "رهن کامل"
        case .rahn:
            label.text = "رهن"
        case .ejare:
            label.text = "اجاره"
        case .feature:
            label.text = "امکانات"
        case .condition:
            label.text = "شرایط"
        case .forosh:
            label.text = "فروش"
        }

        return label
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = snapshot.itemIdentifiers[indexPath.section]
        
        if case .origin(_) = item {
            return 58
        }

        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = snapshot.itemIdentifiers[indexPath.section]
        if case .otaq = section {
            let vc = SelectionTableViewController.create()
            vc.delegate = self
            vc.selectionModels = [SelectionModel(id: "0", title: "بدون اتاق", section: .room),SelectionModel(id: "1", title: "1" + " اتاق", section: .room),SelectionModel(id: "2", title: "2" + " اتاق", section: .room),SelectionModel(id: "3", title: "3" + " اتاق", section: .room),SelectionModel(id: "4", title: "4" + " اتاق", section: .room),SelectionModel(id: "5", title: "5" + " اتاق", section: .room),SelectionModel(id: "6", title: "6" + " اتاق", section: .room)]
            show(vc, sender: nil)
        }
    }
    
    func reload() {
        snapshot = createSnapshot()
        tableViewDataSource.apply(snapshot)
    }
    
    @IBAction func agreeButtonTapped(_ sender: Any) {
        guard let type = addAgahi.type else { return }
        guard !self.featureIds.isEmpty else {
            presentCDAlertWarningAlert(message: "لطفا حداقل یکی از امکانات را انتخاب کنید", completion: {})
            return
        }
        
        guard !self.conditionIds.isEmpty else {
            presentCDAlertWarningAlert(message: "لطفا حداقل یکی از شرایط را انتخاب کنید", completion: {})
            return
        }
        
        let vc = AddAgahiStep5TableViewController.create()

        if type == 1 {
            // forosh
            if (addAgahi.isAgreementPriceBuy ?? false) {
                addAgahi.priceBuy = 0
            } else {
                if addAgahi.priceBuy == 0 {
                    presentCDAlertWarningAlert(message: "لطفا قیمت را وارد کنید", completion: {})
                    return
                }
            }
            
            addAgahi.conditionIDS = conditionIds
            addAgahi.featureIDS = featureIds
            
            vc.addAgahi = addAgahi
            vc.addInfo = addInfo
            
            vc.isUpdate = isUpdate
            vc.agahiModel = agahiModel
            vc.updateEstateID = updateEstateID
            
            show(vc, sender: nil)
        }
        
        if type == 2 {
            // rahn v ejare
            if (addAgahi.isMortgage ?? false) {
                // rahn kamel
                if addAgahi.isAgreementPriceMortgage == true {
                    addAgahi.priceMortgage = 0
                } else {
                    if addAgahi.priceMortgage == 0 {
                        presentCDAlertWarningAlert(message: "لطفا قیمت رهن را تعیین کنید", completion: {})
                        return
                    }
                }
                addAgahi.priceRent = 0
                addAgahi.isAgreementPriceRent = false
            } else {
                if addAgahi.isAgreementPriceMortgage == true {
                    addAgahi.priceMortgage = 0
                } else {
                    if addAgahi.priceMortgage == 0 {
                        presentCDAlertWarningAlert(message: "لطفا قیمت رهن را تعیین کنید", completion: {})
                        return
                    }
                }
                
                if addAgahi.isAgreementPriceRent == true {
                    addAgahi.priceRent = 0
                } else {
                    if addAgahi.priceRent == 0 {
                        presentCDAlertWarningAlert(message: "لطفا قیمت اجاره را تعیین کنید", completion: {})
                        return
                    }
                }
            }

            addAgahi.conditionIDS = conditionIds
            addAgahi.featureIDS = featureIds
            
            vc.addAgahi = addAgahi
            vc.addInfo = addInfo
            show(vc, sender: nil)
        }
    }
}

extension AddAgahiStep4TableViewController: SelectionTableViewControllerDelegate {
    func didselectSection(item: SelectionModel) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let i = snapshot.itemIdentifiers[indexPath.section]
            
            if case .otaq = i {
                addAgahi.countRoom = Int(item.id)!
                reload()
            }
        }
    }
}


extension AddAgahiStep4TableViewController: OriginModelTableViewCellDelegate {
    func TitleTextFieldValueChanged(_ sender: UITextField, cell: OriginModelTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let section = snapshot.sectionIdentifiers[indexPath.section]
            
            if case .rahn = section {
                addAgahi.priceMortgage = Int(sender.text ?? "")
            }
            if case .forosh = section {
                addAgahi.priceBuy = Int(sender.text ?? "")

            }
            if case .ejare = section {
                addAgahi.priceRent = Int(sender.text ?? "")
            }
        }
    }
}

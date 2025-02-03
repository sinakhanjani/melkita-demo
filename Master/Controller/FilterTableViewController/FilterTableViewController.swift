//
//  FilterTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 3/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

let SHIT_NUMBER = 1238127936296

enum Section: Hashable {
    case estayeBaseType // noe agahi buy:1 rent:2 both:0
    case provenance // ostan
    case city // shahr
    case estateUse // noe karbord ya karbari (category)
    case estateType // noe melk (sub category)
    case room
    case meter
    case price
    case newAge // checkbox nosaz
    case condition
    case feature
}

enum Row: Hashable {
    case selection(SelectionModel?)
    case input(SelectionModel?)
    case checkbox(SelectionModel?)
    case dynamicCheckboxFeature(Feature)
    case dynamicCheckboxCondition(Condition)
}

protocol FilterTableViewControllerDelegate {
    func fiterQuerySelected(_ dict: [String: String])
}

class FilterTableViewController: UITableViewController, UITextFieldDelegate, SelectionTableViewControllerDelegate {

    @IBOutlet weak var titleSearchTextField: UITextField!
 
    private var tableViewDataSource: UITableViewDiffableDataSource<Section,Row>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
    var filter = Filter()

    let estayeBaseTypeModels = [SelectionModel(id: "1", title: "خرید و فروش", section: .estayeBaseType),SelectionModel(id: "2", title: "رهن و اجاره", section: .estayeBaseType),SelectionModel(id: "0", title: "هر دو", section: .estayeBaseType)]
    var filterServerResult: FilterServerResult?
    var cities: [City] = []
    var esstateTypeModelElement: [EstateTypeModelElement] = []

    var featureIds: [String] = []
    var conditionIds: [String] = []

    var delegate:FilterTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "فیلتـر"
        updateUI()
        backBarButtonAttribute(color: .black, name: "")
        fetchFilterResult(state: 0)
    }

    func updateUI() {
        titleSearchTextField.delegate = self
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "text.badge.checkmark"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(leftBarButtonTapped))
        leftBarButtonItem.tintColor = .black
        navigationItem.rightBarButtonItem = leftBarButtonItem
        perform()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    @objc func leftBarButtonTapped() {
        var query = filter.convertToDict(features: featureIds, conditions: conditionIds)
        if let searchTerm = titleSearchTextField.text, !searchTerm.isEmpty {
            query.updateValue(searchTerm, forKey: "Key")
        }
        delegate?.fiterQuerySelected(query)
        navigationController?.popViewController(animated: false)
    }
    
    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section,Row> {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Row>()
        snapshot.appendSections([.estayeBaseType,.provenance,.city,.estateUse,.estateType,.room,.meter,.price,.newAge,.condition,.feature])
        
        snapshot.appendItems([.selection(filter.estateBaseType)], toSection: .estayeBaseType)
        snapshot.appendItems([.selection(filter.province)], toSection: .provenance)
        snapshot.appendItems([.selection(filter.city)], toSection: .city)
        snapshot.appendItems([.selection(filter.estateUse)], toSection: .estateUse)
        snapshot.appendItems([.selection(filter.estateType)], toSection: .estateType)
        snapshot.appendItems([.selection(filter.room)], toSection: .room)
        snapshot.appendItems([.input(SelectionModel(id: "\(SHIT_NUMBER)", title: "متراژ از" , section: .meter)), .input(SelectionModel(id: "\(SHIT_NUMBER)", title: "متراژ تا", section: .meter))], toSection: .meter)
        snapshot.appendItems([.input(SelectionModel(id: "\(SHIT_NUMBER)", title: "قیمت از" , section: .price)), .input(SelectionModel(id: "\(SHIT_NUMBER)", title: "قیمت تا", section: .price))], toSection: .price)

        snapshot.appendItems([.checkbox(filter.newAge)], toSection: .newAge)
        
//        // items from server:
        if let conditions = self.filterServerResult?.conditions {
            let items = conditions.map({ Row.dynamicCheckboxCondition($0)})
            snapshot.appendItems(items, toSection: .condition)
        }
        
        if let features = self.filterServerResult?.features {
            let items = features.map({ Row.dynamicCheckboxFeature($0) })
            snapshot.appendItems(items, toSection: .feature)
        }

        return snapshot
    }
    
    private func perform() {
        tableViewDataSource = FiilterTableViewDiffableDataSource(tableView: tableView, vc: self)
        snapshot = createSnapshot()
        tableViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = snapshot.sectionIdentifiers[indexPath.section]
        let vc = SelectionTableViewController.create()
        vc.delegate = self
        switch section {
        case .estayeBaseType:
            vc.selectionModels = estayeBaseTypeModels
            show(vc, sender: nil)
        case .provenance:
            let provinces = (self.filterServerResult?.provinces ?? [])
            let input = provinces.map { (i) -> SelectionModel in
                SelectionModel(id: "\(i.id ?? SHIT_NUMBER)", title: i.name ?? "بدون نام", section: .provenance)
            }
            vc.selectionModels = input
            show(vc, sender: nil)
        case .city:
            let input = cities.map { (i) -> SelectionModel in
                SelectionModel(id: "\(i.id ?? SHIT_NUMBER)", title: i.name ?? "بدون نام", section: .city)
            }
            vc.selectionModels = input
            show(vc, sender: nil)
        case .estateUse:
            let input = (self.filterServerResult?.categories ?? []).map { (i) -> SelectionModel in
                SelectionModel(id: i.id, title: i.title ?? "بدون نام", section: .estateUse)
            }
            vc.selectionModels = input
            show(vc, sender: nil)
        case .estateType:
            let input = self.esstateTypeModelElement.map { (i) -> SelectionModel in
                SelectionModel(id: i.id ?? "\(SHIT_NUMBER)", title: i.title ?? "بدون نام", section: .estateType)
            }
            vc.selectionModels = input
            show(vc, sender: nil)
        case .room:
            vc.selectionModels = [SelectionModel(id: "0", title: "بدون اتاق", section: .room),SelectionModel(id: "1", title: "1" + " اتاق", section: .room),SelectionModel(id: "2", title: "2" + " اتاق", section: .room),SelectionModel(id: "3", title: "3" + " اتاق", section: .room),SelectionModel(id: "4", title: "4" + " اتاق", section: .room),SelectionModel(id: "5", title: "5" + " اتاق", section: .room),SelectionModel(id: "6", title: "6" + " اتاق", section: .room)]
            show(vc, sender: nil)
        case .meter:
            break
        case .price:
            break
        case .newAge:
            break
        case .condition:
            break
        case .feature:
            break
        }
    }
    
    func didselectSection(item: SelectionModel) {
        switch item.section {
        case .estayeBaseType:
            self.filter.estateBaseType = item
            self.fetchFilterResult(state: Int(item.id) ?? SHIT_NUMBER)
        case .provenance:
            self.filter.province = item
            self.fetchCity(provId: Int(item.id) ?? SHIT_NUMBER)
        case .city:
            self.filter.city = item
        case .estateUse:
            self.filter.estateUse = item
            self.fetchEstateType(catID: item.id)
        case .estateType:
            self.filter.estateType = item
        case .room:
            self.filter.room = item
        case .meter:
            break
        case .price:
            break
        case .newAge:
            break
        case .condition:
            break
        case .feature:
            break
        }
        snapshot = createSnapshot()
        tableViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont.persianFont(size: 17)
        label.textAlignment = .right
        label.textColor = .black
        let snapshotItem = self.snapshot
        let sc = snapshotItem.sectionIdentifiers[section]
        var name: String?
        
        switch sc {
        case .estayeBaseType:
            name = "نوع آگهی"
        case .provenance:
            name = "استان"

        case .city:
            name = "شهر"

        case .estateUse:
            name = "نوع کاربرد"

        case .estateType:
            name = "نوع ملک"

        case .room:
            name = "تعداد اتاق"

        case .meter:
            name = "متراژ"

        case .price:
            name = "قیمت"

        case .newAge:
            name = "مدت ساخت"

        case .condition:
            name = "شرایط"

        case .feature:
            name = "امکانات ملک"
        }
        
        label.text = name

        return label
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
}

extension FilterTableViewController: TextFieldTableViewCellDelegate {
    func textFieldInputValueChanged(_ sender: UITextField) {
        if sender.placeholder == "متراژ از" {
            filter.meterFrom = SelectionModel(id: sender.text!, title: "متراژ از" , section: .meter)
        }
        if sender.placeholder == "متراژ تا" {
            filter.MeterTo = SelectionModel(id: sender.text!, title: "متراژ تا", section: .meter)
        }
        if sender.placeholder == "قیمت از" {
            filter.priceFrom = SelectionModel(id: sender.text!, title: "قیمت از", section: .price)
        }
        if sender.placeholder == "قیمت تا" {
            filter.priceTo = SelectionModel(id: sender.text!, title: "قیمت تا", section: .price)
        }
    }
}

extension FilterTableViewController {
    func newAgeCheckBoxValueChange(_ status: Bool) {
        filter.newAge = SelectionModel(id: "\(status ? "1":"0")", title: "نوساز", section: .newAge)
        snapshot = createSnapshot()
        tableViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    func dynamticCheckBoxFeature(_ status: Bool, indexPath: IndexPath) {
        if let items = self.filterServerResult?.features {
            self.filterServerResult?.features?[indexPath.row].isCheck = status
            
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
        snapshot = createSnapshot()
        tableViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    func dynamticCheckBoxCondition(_ status: Bool, indexPath: IndexPath) {
        if let items = self.filterServerResult?.conditions {
            self.filterServerResult?.conditions?[indexPath.row].isCheck = status

            let item = items[indexPath.row]

            let index = self.conditionIds.lastIndex { (i) -> Bool in
                return i == item.id
            }
            
            if let index = index {
                self.conditionIds.remove(at: index)
            } else {
                self.conditionIds.append(item.id)
            }
        }
        
        snapshot = createSnapshot()
        tableViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
}


class FiilterTableViewDiffableDataSource: UITableViewDiffableDataSource<Section,Row> {
    init(tableView: UITableView, vc: FilterTableViewController) {
        super.init(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            switch item {
            case .selection(let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: "selection")!
                cell.textLabel?.text = item?.title ?? "انتخاب کنید"
                cell.accessoryType = .disclosureIndicator
                
                return cell
            case .input(let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier) as! TextFieldTableViewCell
                cell.nameTextField.placeholder = item?.title
                cell.delegate = vc
                if item?.id != "\(SHIT_NUMBER)" {
                    cell.nameTextField.text = (item?.id ?? "")
                } else {
                    
                }
                
                return cell
            case .checkbox(let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.identifier) as! CheckBoxTableViewCell
                cell.checkBox.valueChanged = vc.newAgeCheckBoxValueChange

                if let id = item?.id, id != "\(SHIT_NUMBER)" {
                    cell.titleLabel.text = item?.title
                    cell.checkBox.isChecked = (id == "0") ? false:true
                } else {
                    cell.titleLabel.text = item?.title
                    cell.checkBox.isChecked = false
                }
                
                return cell
            case .dynamicCheckboxFeature(let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.identifier) as! CheckBoxTableViewCell
                cell.titleLabel.text = item.title
                cell.checkBox.valueChanged = { status in
                    vc.dynamticCheckBoxFeature(status, indexPath: indexPath)
                }
                cell.checkBox.isChecked = item.isCheck ?? false

                return cell
            case .dynamicCheckboxCondition(let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.identifier) as! CheckBoxTableViewCell
                cell.titleLabel.text = item.title
                cell.checkBox.valueChanged = { status in
                    vc.dynamticCheckBoxCondition(status, indexPath: indexPath)
                }
                cell.checkBox.isChecked = item.isCheck ?? false

                return cell
            }
        }
        
    }
}


extension FilterTableViewController {
    func fetchFilterResult(state: Int) {
        self.startIndicatorAnimate()
        RestfulAPI<Empty,FilterServerResult>.init(path: "/Common/filter/info/\(state)").with(method: .GET)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.filterServerResult = res
                        self.snapshot = self.createSnapshot()
                        self.tableViewDataSource.apply(self.snapshot, animatingDifferences: true, completion: nil)
                    case .failure(_):
                        break
                    }
                }
            }
    }
    
    func fetchCity(provId: Int) {
        self.startIndicatorAnimate()
        RestfulAPI<Empty,[City]>.init(path: "/Common/cities/\(provId)")
        .with(method: .GET)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.cities = res
                    case .failure(_):
                        break
                    }
                }
            }
    }
    
    func fetchEstateType(catID: String) {
        self.startIndicatorAnimate()
        RestfulAPI<Empty,[EstateTypeModelElement]>.init(path: "/Common/estate/types/\(catID)")
        .with(method: .GET)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.esstateTypeModelElement = res
                        break
                    case .failure(_):
                        break
                    }
                }
            }
    }
}

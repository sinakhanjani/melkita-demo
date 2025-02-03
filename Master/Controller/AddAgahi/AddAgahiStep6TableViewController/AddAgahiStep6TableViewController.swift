//
//  AddAgahiStep6TableViewController.swift
//  Master
//
//  Created by Sina khanjani on 4/27/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

struct AddAgahiRes: Codable {
    let urlPay: String?
    let estateId: String?
}

class AddAgahiStep6TableViewController: UITableViewController {
    
    enum Section {
        case sanad
        case saze
        case moqeyat
        case nama
    }
    
    enum AgahiRow4: Hashable {
        case noeSanad(SelectionModel?) // [BuildingDoc]
        case noeSaze(SelectionModel?) // [BuildingDoc]
        case dynamicCheckboxMoqeyat(Building)
        case dynamicCheckboxNama(Building)
    }

    private var tableViewDataSource: UITableViewDiffableDataSource<Section,AgahiRow4>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, AgahiRow4>()
    
    var addAgahi = AddAgahiModelBody()
    var addInfo: AddInfo?
    
    var sanad: SelectionModel = SelectionModel(id: "0", title: "نوع سند را انتخاب کنید", section: .city)
    var saze: SelectionModel = SelectionModel(id: "0", title: "نوع سازه را انتخاب کنید", section: .city)

    var positionsIds: [String] = []
    var namaIds: [String] = []

    var isUpdate = false
    var updateEstateID: String?
    var agahiModel: AgahiModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .black, name: "")
        title = "ثبت آگهی"
        if isUpdate {
            sanad.title = agahiModel?.buildingDocument?.title ?? ""
            saze.title = agahiModel?.buildingStructureType?.title ?? ""
            
            
            if let position = agahiModel?.buildingPositionEstate {
                let ids = position.map { $0.buildingPosition!.id! }
                self.positionsIds = ids
            }
            if let views = agahiModel?.viewTypeBuildingEstate {
                let ids = views.map { $0.viewTypeBuilding!.id! }
                self.namaIds = ids
            }
            
            self.sanad.id = agahiModel?.buildingDocument?.id ?? ""
            self.saze.id = agahiModel?.buildingStructureType?.id ?? ""
            addAgahi.buildingDocumentID = agahiModel?.buildingDocument?.id
            addAgahi.buildingStructureTypeID = agahiModel?.buildingStructureType?.id
        }
        perform()
    }
    
    func reload() {
        snapshot = createSnapshot()
        tableViewDataSource.apply(snapshot)
    }
    
    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section,AgahiRow4> {
        var snapshot = NSDiffableDataSourceSnapshot<Section,AgahiRow4>()
        
        snapshot.appendSections([.sanad])
        snapshot.appendItems([.noeSanad(sanad)], toSection: .sanad)
        
        snapshot.appendSections([.saze])
        snapshot.appendItems([.noeSaze(saze)], toSection: .saze)
        
        if let items = addInfo?.buildingPositions {
            let converted = items.map { AgahiRow4.dynamicCheckboxMoqeyat($0)}
            snapshot.appendSections([.moqeyat])
            snapshot.appendItems(converted, toSection: .moqeyat)
        }
        if let items = addInfo?.buildingViewTypes {
            let converted = items.map { AgahiRow4.dynamicCheckboxNama($0)}
            snapshot.appendSections([.nama])
            snapshot.appendItems(converted, toSection: .nama)
        }
        
        return snapshot
    }
    
    private func perform() {
        tableViewDataSource = .init(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            switch item {
            case .noeSanad(let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: "selection")!
                cell.textLabel?.text = item?.title ?? "انتخاب کنید"
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = item?.title

                return cell
                
            case .noeSaze(let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: "selection")!
                cell.textLabel?.text = item?.title ?? "انتخاب کنید"
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = item?.title
                
                return cell
            case .dynamicCheckboxMoqeyat(let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.identifier) as! CheckBoxTableViewCell // buildingPositions
                cell.titleLabel.text = item.title
                cell.checkBox.isChecked = item.isCheck ?? false
                cell.checkBox.valueChanged = { status in
                    if let items = self.addInfo?.buildingPositions {
                        self.addInfo?.buildingPositions?[indexPath.row].isCheck = status
                        
                        let item = items[indexPath.row]

                        let index = self.positionsIds.lastIndex { (i) -> Bool in
                            return i == item.id
                        }
                        
                        if let index = index {
                            self.positionsIds.remove(at: index)
                        } else {
                            self.positionsIds.append(item.id)
                        }
                    }
                    self.reload()
                }

                return cell
            case .dynamicCheckboxNama(let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.identifier) as! CheckBoxTableViewCell
                cell.titleLabel.text = item.title
                cell.checkBox.isChecked = item.isCheck ?? false
                cell.checkBox.valueChanged = { status in
                    if let items = self.addInfo?.buildingViewTypes {
                        self.addInfo?.buildingViewTypes?[indexPath.row].isCheck = status
                        
                        let item = items[indexPath.row]

                        let index = self.namaIds.lastIndex { (i) -> Bool in
                            return i == item.id
                        }
                        
                        if let index = index {
                            self.namaIds.remove(at: index)
                        } else {
                            self.namaIds.append(item.id)
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
        let item = snapshot.sectionIdentifiers[section]
        let label = UILabel()
        label.font = UIFont.persianFont(size: 17)
        label.textAlignment = .right
        label.textColor = .black
        label.text = ""
        
        switch item {
        case .sanad:
            label.text = "سند"
        case .saze:
            label.text = "سازه"
        case .moqeyat:
            label.text = "موقعیت"
        case .nama:
            label.text = "نما"
        }
        
        return label
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        58
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = snapshot.itemIdentifiers[indexPath.section]

        if case .noeSanad(_) = section {
            let vc = SelectionTableViewController.create()
            vc.delegate = self
            if let items = self.addInfo?.buildingDocs {
                vc.selectionModels = items.map { SelectionModel(id: $0.id ?? "", title: $0.title ?? "", section: .city) }
            }
            
            show(vc, sender: nil)
        }
        
        if case .noeSaze(_) = section {
            let vc = SelectionTableViewController.create()
            vc.delegate = self
            if let items = self.addInfo?.buildingStructureTypes {
                vc.selectionModels = items.map { SelectionModel(id: $0.id ?? "", title: $0.title ?? "", section: .city) }
            }
            
            show(vc, sender: nil)
        }
    }
    
    func addAgahiRequest(addAgahiStatus: AddAgahiStatus) {
        print(addAgahi)
        startIndicatorAnimate()
        RestfulAPI<AddAgahiModelBody,GenericOrginal<AddAgahiRes>>.init(path: "/Estate")
            .with(method: .POST)
            .with(auth: .user)
            .with(body: addAgahi)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        if res.isSuccess == true {
                            if addAgahiStatus.isFreeAddEstate == true {
                                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                            } else {
                                self.goToNext(id: res.data?.estateId ?? "X", price: addAgahiStatus.addEstatePrice, discountPrice: addAgahiStatus.discountPrice, type: 4)
                            }
                        } else {
                            self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                        }

                    case .failure(_):
                        break
                    }
                }
            }
    }
    
    func tamdidAgahiRequest(addAgahiStatus: AddAgahiStatus) {
        guard let stateID = self.updateEstateID else {
            return
        }
        let body = TamdidAgahiModel(addAgahi: addAgahi, estateID: stateID)
        startIndicatorAnimate()
        RestfulAPI<TamdidAgahiModel,GenericOrginal<AddAgahiRes>>.init(path: "/Estate")
            .with(method: .PUT)
            .with(auth: .user)
            .with(body: body)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        if res.isSuccess == true {
//                            self.goToNext(id: stateID, price: addAgahiStatus.addEstatePrice, discountPrice: addAgahiStatus.discountPrice, type: 5)
                            self.navigationController?.popToRootViewController(animated: true)
                        } else {
                            self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                        }
                    case .failure(_):
                        break
                    }
                }
            }
    }
    
    func fetchAddPrice(id: String) {
        startIndicatorAnimate()
        RestfulAPI<Empty,AddAgahiStatus>.init(path: "/Estate/price-add/\(id)")
            .with(method: .GET)
            .with(auth: .user)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.addAgahiRequest(addAgahiStatus: res)
                    case .failure(_):
                        break
                    }
                }
            }
    }
    
    func fetchUpdatePrice(id: String) {
        startIndicatorAnimate()
        RestfulAPI<Empty,AddAgahiStatus>.init(path: "/Estate/price-add/\(id)")
            .with(method: .GET)
            .with(auth: .user)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        // updateRequest here ***
                        // type = 5
                        self.tamdidAgahiRequest(addAgahiStatus: res)
                    case .failure(_):
                        break
                    }
                }
            }
    }
    
    func goToNext(id: String, price: Int?, discountPrice: Int?, type: Int) {
        let nav = UINavigationController.create(withId: "UINavigationControllerPayment") as! UINavigationController
        let vc = nav.viewControllers.first as! PaymentTableViewController
        vc.type = type
        vc.rcPayment = RCPaymentModel(price: price, discountPrice: discountPrice)
        vc.estateID = id
        
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func agreeButtonTapped(_ sender: Any) {
        if addAgahi.type == 1 {
            // forosh - sanad v saze ejbari
            if sanad.id == "0" || saze.id == "0" {
                presentCDAlertWarningAlert(message: "لطفا نوع سند و سازه را انتخاب کنید", completion: {})
                return
            }
            addAgahi.buildingDocumentID = sanad.id
            addAgahi.buildingStructureTypeID = saze.id
        }
        if addAgahi.type == 2 {
            // rahn ejare
            if sanad.id != "0" {
                addAgahi.buildingDocumentID = sanad.id
            }
            if saze.id != "0" {
                addAgahi.buildingStructureTypeID = saze.id
            }
        }
        
        if !positionsIds.isEmpty {
            addAgahi.buildingPositionIDS = positionsIds
        }
        if !namaIds.isEmpty {
            addAgahi.viewTypeBuildingIDS = namaIds
        }
        if let catId = addAgahi.estateUseID {
            if isUpdate {
                self.fetchUpdatePrice(id: catId)
            } else {
                self.fetchAddPrice(id: catId)
            }
        }
    }
}

extension AddAgahiStep6TableViewController:SelectionTableViewControllerDelegate {
    func didselectSection(item: SelectionModel) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let section = snapshot.itemIdentifiers[indexPath.section]
            if case .noeSanad(_) = section {
                self.sanad = item
                self.reload()
            }
            
            if case .noeSaze(_) = section {
                self.saze = item
                self.reload()
            }
        }
    }
}

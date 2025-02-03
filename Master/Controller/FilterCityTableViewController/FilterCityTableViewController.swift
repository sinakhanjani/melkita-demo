//
//  FilterCityTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/12/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class FilterCityTableViewController: UITableViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isCityVC: Bool = false
    var provinceID: Int?
    
    var isAllSelected = false
    var addCities = [City]()

    static var selectedProvinces: [Province] = []
    static var selectedCities: [City] = []
    
    var cities = [City]()
    var provinces = [Province]()
    
    var delegate:FilterTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .blue, name: "")
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "text.badge.checkmark"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(leftBarButtonTapped))
        leftBarButtonItem.tintColor = .black
        navigationItem.rightBarButtonItem = leftBarButtonItem
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        
        title = "فیلتر شهر‌ها"
        if isCityVC {
            if let provinceID = self.provinceID {
                fetchCity(provId: provinceID)
                cities.append(City(id: provinceID*12, province: nil, name: "تمام شهرها", latitude: nil, longitude: nil, isActive: nil, isDelete: nil, modifiedDate: nil))
            }
            delegate = self.navigationController?.viewControllers.first as! HomeViewController
            
        } else {
            fetchProvinces()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    @objc func leftBarButtonTapped() {
        guard !FilterCityTableViewController.selectedCities.isEmpty else {
            navigationController?.popToRootViewController(animated: true)
            return
        }
        var ids = FilterCityTableViewController.selectedCities.map { "\($0.id!)" }
        if let index = ids.lastIndex(where: { i in
            return i == "\((provinceID ?? 49)*12)"
        }) {
            ids.remove(at: index)
        }
        let send = ids.joined(separator: ",")
        
        var query: [String: String] = [:]
        query.updateValue(send, forKey: "City")
        query.updateValue("1", forKey: "Page")
        query.updateValue("1000", forKey: "PageSize")

        self.delegate?.fiterQuerySelected(query)
        navigationController?.popToRootViewController(animated: false)
    }
    
    func fetchProvinces() {
        RestfulAPI<EMPTYMODEL,[Province]>.init(path: "Common/provinces")
            .with(method: .GET)
            .sendURLSessionRequest { result in
                if case .success(let items) = result {
                    self.provinces = items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
                        self.cities += res
                        for (index,city) in self.cities.enumerated() {
                            if FilterCityTableViewController.selectedCities.contains(city) {
                                self.cities[index].isSelected = true
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    case .failure(_):
                        break
                    }
                }
            }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isCityVC ? cities.count:provinces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        if isCityVC {
            let item = cities[indexPath.item]
            cell.textLabel?.text = item.name
            if indexPath.item == 0 {
                // tamame shahrh
                if (isAllSelected) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            } else {
                if (item.isSelected ?? false) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
        } else {
            let item = provinces[indexPath.item]
            cell.textLabel?.text = item.name
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isCityVC {
            let item = cities[indexPath.item]
            if indexPath.item == 0 {
                if isAllSelected {
                    for (index,_) in cities.enumerated() {
                        cities[index].isSelected = false
                    }
                    
                    let endCounter = addCities.count
                    let count = FilterCityTableViewController.selectedCities.count
                    if count >= endCounter {
                        let range = (count-endCounter)...(count-1)
                        FilterCityTableViewController.selectedCities.removeSubrange(range)
                    }

                    addCities = []
                } else {
                    for (index,_) in cities.enumerated() {
                        cities[index].isSelected = true
                    }
                    
                    addCities = cities

                    FilterCityTableViewController.selectedCities.append(contentsOf: addCities)
                    FilterCityTableViewController.selectedCities.removeDuplicates()
                }
                
                self.collectionView.reloadData()
                self.tableView.reloadData()
                
                isAllSelected.toggle()
            } else {
                if let index = FilterCityTableViewController.selectedCities.firstIndex(where: { i in
                    return i.id == item.id
                }) {
                    FilterCityTableViewController.selectedCities.remove(at: index)
                    cities[indexPath.item].isSelected = false
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    collectionView.reloadData()
                } else {
                    if let cell = tableView.cellForRow(at: indexPath) {
                        cell.accessoryType = .checkmark
                        cities[indexPath.item].isSelected = true
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                    FilterCityTableViewController.selectedCities.append(item)
                    FilterCityTableViewController.selectedCities.removeDuplicates()

                    collectionView.reloadData()
                }
            }
        } else {
                // province selected here
            let vc = FilterCityTableViewController.create()
            vc.provinceID = provinces[indexPath.item].id
            vc.isCityVC = true
            show(vc, sender: nil)
        }
    }
    
    func removeCityCheckmarkStatus(id: Int) {
        if let index = cities.firstIndex(where: { i in
            return i.id == id
        }) {
            cities[index].isSelected = false
            tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        }
    }
}

extension FilterCityTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FilterCityTableViewController.selectedCities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.delegate = self
        if let title = FilterCityTableViewController.selectedCities[indexPath.item].name {
            cell.button1.setTitle(title, for: .normal)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize.init(width: collectionView.frame.height, height: collectionView.frame.height)
        return CGSize.init(width: 114, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func button2Tapped(sender: UIButton, cell: CollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let item = FilterCityTableViewController.selectedCities[indexPath.item]
            FilterCityTableViewController.selectedCities.remove(at: indexPath.item)
            // remove checkmark from table
            if let cityID = item.id {
                removeCityCheckmarkStatus(id: cityID)
            }
            collectionView.reloadData()
        }
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

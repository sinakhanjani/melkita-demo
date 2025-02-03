//
//  SelectionTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 3/12/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit

protocol SelectionTableViewControllerDelegate {
    func didselectSection(item: SelectionModel)
}

class SelectionTableViewController: UITableViewController {
    
    enum Section {
        case main
    }
    
    var selectionModels: [SelectionModel]?
    var selectedIndexPath: IndexPath?
    var delegate:SelectionTableViewControllerDelegate?

    private var tableViewDataSource: UITableViewDiffableDataSource<Section,SelectionModel>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, SelectionModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        perform()
        backBarButtonAttribute(color: .black, name: "")
    }
    
    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section,SelectionModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Section,SelectionModel>()
        if let selectionModels = self.selectionModels {
            snapshot.appendSections([.main])
            snapshot.appendItems(selectionModels)
        }
        
        return snapshot
    }
    
    private func perform() {
        tableViewDataSource = UITableViewDiffableDataSource<Section,SelectionModel>.init(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            
            cell.textLabel?.text = item.title
            
            if let selectedIndexPath = self.selectedIndexPath {
                if selectedIndexPath == indexPath {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        })
        snapshot = createSnapshot()
        tableViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let cell = tableView.cellForRow(at: indexPath)
            
            if selectedIndexPath == indexPath {
                cell?.accessoryType = .none
            } else {
                cell?.accessoryType = .checkmark
                navigationController?.popViewController(animated: true)
                delegate?.didselectSection(item: self.selectionModels![indexPath.item])
            }
            
            self.selectedIndexPath = indexPath
            tableViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }
    }
}

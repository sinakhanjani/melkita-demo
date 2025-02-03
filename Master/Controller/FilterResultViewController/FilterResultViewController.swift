//
//  FilterViewController.swift
//  Master
//
//  Created by Sina khanjani on 3/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import  RestfulAPI

class FilterResultViewController: UIViewController {
    
    enum Section: Hashable {
        case advertise
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, Estate>()
    var dataSource: UICollectionViewDiffableDataSource<Section, Estate>!
    
    var items:[Estate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    func updateUI() {
        backBarButtonAttribute(color: .black, name: "")
    }
    
    func perform() {
        collectionView.collectionViewLayout = createLayout()
        registerCollectionViewCell(collectionView: collectionView, cell: HomeAdvertiseCollectionViewCell.self)

        configureDataSource()
        snapshot = createSnapshot()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self.snapshot.sectionIdentifiers[sectionIndex]
            switch section {
            case .advertise:
                // MARK: Promoted Section Layout
                let height: CGFloat = 160
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                                
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 20, trailing: 8)
                
                return section
                
            }
        }
        
        return layout
    }
    
    func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let section = self.snapshot.sectionIdentifiers[indexPath.section]
            switch section {
            case .advertise:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeAdvertiseCollectionViewCell.identifier, for: indexPath) as! HomeAdvertiseCollectionViewCell
                
                return cell
            }
        })
    }
    

    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Estate> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Estate>()
        snapshot.appendSections([.advertise])
        snapshot.appendItems(items, toSection: .advertise)

        return snapshot
    }
}

extension FilterResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        let vc = AgahiTableViewController.create()
        vc.estateID = item.id
        show(vc, sender: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // paggination
    }
}


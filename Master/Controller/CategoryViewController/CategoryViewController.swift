//
//  CategoryViewController.swift
//  Master
//
//  Created by Sina khanjani on 3/18/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    enum Section {
        case main
    }
    
    var items:[Category] = []
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, Category>()
    var dataSource: UICollectionViewDiffableDataSource<Section, Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "نوع کاربری"
        collectionView.delegate = self
        fetch()
        backBarButtonAttribute(color: .black, name: "")
    }

    func fetch() {
        startIndicatorAnimate()
        RestfulAPI<Empty,[Category]>.init(path: "/Common/categories/estate")
            .with(method: .GET)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.items = res
                        self.perform()
                    case .failure(_):
                        break
                    }
                }
            }
    }
    
    func perform() {
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        snapshot = createSnapshot()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            // MARK: Promoted Section Layout
            let height: CGFloat = 58
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                            
            let section = NSCollectionLayoutSection(group: group)

            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 20, trailing: 8)
            
            return section
        }
        
        return layout
    }
    
    func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            cell.titleLabel.text = item.title

            return cell
        })
    }

    func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Category> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Category>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(items)

        return snapshot
    }
}


extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SubCategoryViewController.create()
        vc.id = self.items[indexPath.item].id
        show(vc, sender: nil)
    }
}

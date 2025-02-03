//
//  SubCategoryViewController.swift
//  Master
//
//  Created by Sina khanjani on 3/18/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class SubCategoryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    enum Section {
        case main
    }
    
    var items:[EstateTypeModelElement] = []
    var id: String?
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, EstateTypeModelElement>()
    var dataSource: UICollectionViewDiffableDataSource<Section, EstateTypeModelElement>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "نوع ملک"
        collectionView.delegate = self
        fetchSub(id: id ?? "")
        backBarButtonAttribute(color: .black, name: "")
    }
    
    func fetchSub(id: String) {
        self.startIndicatorAnimate()
        RestfulAPI<Empty,[EstateTypeModelElement]>.init(path: "/Common/estate/types/\(id)")
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

    func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, EstateTypeModelElement> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, EstateTypeModelElement>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(items)

        return snapshot
    }
}


extension SubCategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        if let catId = self.id,let subID = item.id {
            let vc = SearchResultCollectionViewController.create()
            vc.query = ["EstateUseId":"\(catId)","EstateTypeId":subID]
            show(vc, sender: nil)
        }
    }
}

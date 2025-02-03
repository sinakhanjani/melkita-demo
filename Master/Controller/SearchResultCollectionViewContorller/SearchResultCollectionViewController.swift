//
//  SearchResultCollectionViewController.swift
//  Master
//
//  Created by Sina khanjani on 3/18/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

private let reuseIdentifier = "Cell"

class SearchResultCollectionViewController: UICollectionViewController, LoveDelegate {

    func loveButtonTapped(cell: UICollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let item = items[indexPath.item]
            if let id = item.id {
                saveRequest(id: id)
            }
        }
    }
    
    
    func saveRequest(id: String) {
        struct Send: Codable {
            let estateId: String
        }
        RestfulAPI<Send,Generic>.init(path: "/FavoList")
            .with(auth: .user)
            .with(method: .POST)
            .with(body: Send(estateId: id))
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
    }
    
    enum Section {
        case main
    }

    var items:[Estate] = []
    var query: [String:String] = [:]

    
    var snapshot = NSDiffableDataSourceSnapshot<Section, Estate>()
    var dataSource: UICollectionViewDiffableDataSource<Section, Estate>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        perform()
        fetch()
        title = "نتیجـه جستجـو"
        backBarButtonAttribute(color: .black, name: "")
    }
    
    func fetch() {
        startIndicatorAnimate()
        
        var q = query
        q.updateValue("1", forKey: "Page")
        q.updateValue("10000", forKey: "PageSize")
        
        RestfulAPI<Empty,[Estate]>.init(path: "/Estate/ios")
            .with(method: .GET)
            .with(queries: q)
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
        registerCollectionViewCell(collectionView: collectionView, cell: HomeAdvertiseCollectionViewCell.self)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: "main.header", withReuseIdentifier: "main.header")

        configureDataSource()
        snapshot = createSnapshot()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            //add header
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(54))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "main.header", alignment: .top)
            let supplementaryItemContentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
            headerItem.contentInsets = supplementaryItemContentInsets
            
            // MARK: Promoted Section Layout
            let height: CGFloat = 160
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                            
            let section = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior = .groupPagingCentered
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 20, trailing: 8)
            
            return section

        }
        
        return layout
    }
    
    func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeAdvertiseCollectionViewCell.identifier, for: indexPath) as! HomeAdvertiseCollectionViewCell
            cell.delegate = self
            
            
            if let modifiedDateStr = item.modifiedDate, let modifiedDate = modifiedDateStr.toDate() {
                cell.dateLabel.text = Date.behind(exDate: modifiedDate)
            }
            if let price = item.priceBuy, price > 0 {
                cell.tagButton.setTitle("برای فروش", for: .normal)
                cell.tagButton.alpha = 1
            } else {
                if item.isAgreementPriceBuy == true {
                    cell.tagButton.setTitle("برای فروش", for: .normal)
                    cell.tagButton.alpha = 1
                } else {
                    cell.tagButton.alpha = 1
                    cell.tagButton.setTitle("رهن/اجاره", for: .normal)
                }
            }
            
            cell.nameLabel.text = item.title ?? nil
            cell.addressLabel.text = (item.city ?? "") + " - " + (item.province ?? "")
            if let buyPRice = item.priceBuy, buyPRice != 0 {
                cell.buyPriceLabel.text = "قیمت خرید: " + buyPRice.seperateByCama + " تومان"
            } else {
                cell.buyPriceLabel.text = nil
            }
            if let priceMortgage = item.priceMortgage, priceMortgage != 0  {
                cell.buyPriceLabel.text = "قیمت رهن: " + priceMortgage.seperateByCama + " تومان"
            }
            if let sellPrice = item.priceRent, sellPrice != 0 {
                cell.sellPriceLabel.text = "قیمت اجاره: " + sellPrice.seperateByCama + " تومان"
            } else {
                cell.sellPriceLabel.text = nil
            }
            if let imgURLs = item.pictures {
                if !imgURLs.isEmpty {
                    cell.imageVIew.loadImageUsingCache(withUrl: imgURLs[0].picURL ?? "")
                }
            }
            
            return cell
        })
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Estate> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Estate>()
        // MARK: Snapshot Definition
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)

        return snapshot
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AgahiTableViewController.create()
        let item = items[indexPath.item]
        vc.estateID = item.id
        show(vc, sender: nil)
    }
}

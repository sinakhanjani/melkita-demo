//
//  HomeViewController.swift
//  Master
//
//  Created by Sina khanjani on 3/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class HomeViewController: AppViewController, UITextFieldDelegate, FilterTableViewControllerDelegate {
    
    
    func fiterQuerySelected(_ dict: [String : String]) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
            let vc = SearchResultCollectionViewController.create()
            vc.query = dict
            self.show(vc, sender: nil)
        }
    }
    
    private let toSearchResultViewController = "toSearchResultViewController"
    
    enum Section: Hashable {
        case main(BannerModel)
        case advertise
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterTextField: UITextField!
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, Estate>()
    var dataSource: UICollectionViewDiffableDataSource<Section, Estate>!
    
    var sectionItems: BannerModels = []
    var items:[Estate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FilterCityTableViewController.selectedCities = []
        FilterCityTableViewController.selectedProvinces = []
        AppDelegate.fetchUserInfoRequest()
        AppDelegate.fetchRole()
        ErsalMadarekTableViewController.fetchDocumentStatus { _ in}
        fetchNotifi()
    }

    
    func fetchNotifi() {
        // MARK: - Notif
//        struct Notif: Codable {
//            let messageUnReadCount, ticketUnReadCount, chatUnReadCount: Int?
//        }
        RestfulAPI<EMPTYMODEL,Notif>.init(path: "/User/notification")
            .with(method: .GET)
            .with(auth: .user)
            .sendURLSessionRequest { result in
                DispatchQueue.main.async {
                    if case .success(let res) = result {
                        DataManager.shared.notif = res
                        if let items = self.tabBarController?.tabBar.items {
                            if let count = res.chatUnReadCount, count > 0 {
                                items[1].badgeValue = "\(count)"
                                items[1].badgeColor = .red
                                let adad = (res.messageUnReadCount ?? 0) + (res.ticketUnReadCount ?? 0)
                                if adad > 0 {
                                    items[0].badgeValue = "\(adad)"
                                    items[0].badgeColor = .red
                                }
                            } else {
                                items[1].badgeValue = nil
                                items[1].badgeColor = nil
                                let adad = (res.messageUnReadCount ?? 0) + (res.ticketUnReadCount ?? 0)
                                if adad <= 0 {
                                    items[0].badgeValue = nil
                                    items[0].badgeColor = nil
                                }
                                if adad > 0 {
                                    items[0].badgeValue = "\(adad)"
                                    items[0].badgeColor = .red
                                }
                            }
                        }
                    }
                }
            }
    }
    
    @IBAction func searchTextFieldValueChanged(_ sender: UITextField) {
        //
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var searchQuery:[String: String] = [:]

        let searchTerm = textField.text!

        if !searchTerm.isEmpty {
            searchQuery.updateValue(searchTerm, forKey: "Key")
        }
        
        let vc = SearchResultCollectionViewController.create()
        vc.query = searchQuery
        self.show(vc, sender: nil)
        
        return true
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        let vc = FilterTableViewController.create()
        vc.delegate = self
        
        show(vc, sender: nil)
    }
    
    func updateUI() {
        filterTextField.delegate = self
        backBarButtonAttribute(color: .black, name: "")
        fetch()
    }
    
    func fetch() {
        fetchTop()
        fetchBottom()
    }
    
    func fetchTop() {
        RestfulAPI<Empty,BannerModels>.init(path: "/Common/box")
            .with(method: .GET)
            .with(queries: ["Page":"1", "PageSize":"10000"])
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let res):
                        self.sectionItems = res.filter({ !$0.estates.isEmpty })
                        self.perform()
                    case .failure(_):
                        break
                    }
                }
            }
    }
    
    func fetchBottom() {
        RestfulAPI<Empty,[Estate]>.init(path: "/Estate")
            .with(method: .GET)
            .with(queries: ["Page":"1", "PageSize":"10000"])
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
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
        registerCollectionViewCell(collectionView: collectionView, cell: HomeBannerAdvertiseCollectionViewCell.self)
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
            
            let section = self.snapshot.sectionIdentifiers[sectionIndex]
            switch section {
            case .main:
                // MARK: Standard Section Layout
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalWidth(0.7))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                                                 
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.boundarySupplementaryItems = [headerItem]
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 20, trailing: 8)
                
                return section
            case .advertise:
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
        }
        
        return layout
    }
    
    func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let section = self.snapshot.sectionIdentifiers[indexPath.section]
            switch section {
            case .main:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBannerAdvertiseCollectionViewCell.identifier, for: indexPath) as! HomeBannerAdvertiseCollectionViewCell
                cell.delegate = self
                cell.titleLabel.text = item.estateType
                cell.addressLabel.text = (item.city ?? "") + " - " + (item.province ?? "")
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
                if let imgURLs = item.pictures {
                    if !imgURLs.isEmpty {
                        cell.imageVIew.loadImageUsingCache(withUrl: imgURLs[0].picURL ?? "")
                    }
                }
                if let modifiedDateStr = item.modifiedDate, let modifiedDate = modifiedDateStr.toDate() {
                    cell.dateLabel.text = Date.behind(exDate: modifiedDate)
                }
                return cell
            case .advertise:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeAdvertiseCollectionViewCell.identifier, for: indexPath) as! HomeAdvertiseCollectionViewCell
                if let modifiedDateStr = item.modifiedDate, let modifiedDate = modifiedDateStr.toDate() {
                    cell.dateLabel.text = Date.behind(exDate: modifiedDate)
                }
                cell.delegate = self
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
                return cell
            }
        })
        
//         MARK: Supplementary View Provider
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case "main.header":
                let section = self.snapshot.sectionIdentifiers[indexPath.section]
                var headerTitle: String?
                
                switch section {
                case .main(let headerItem):
                    headerTitle = headerItem.title
                default: break
                }

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: "main.header", withReuseIdentifier: "main.header", for: indexPath) as! SectionHeaderView
                headerView.setTitle(headerTitle ?? "")

                return headerView
            default:
                return nil
            }
        }
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Estate> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Estate>()
        // MARK: Snapshot Definition
        sectionItems.forEach { (section) in
            snapshot.appendSections([.main(section)])
            snapshot.appendItems(section.estates, toSection: .main(section))
        }

        snapshot.appendSections([.advertise])
        snapshot.appendItems(items, toSection: .advertise)

        return snapshot
    }
    
    @IBAction func cityFilterButtonTapped(_ sender: Any) {
        let vc = FilterCityTableViewController.create()
        vc.delegate = self
        show(vc, sender: nil)
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = snapshot.sectionIdentifiers[indexPath.section]
        switch section {
        case .main(let mainSection):
            let item = mainSection.estates[indexPath.item]
            // estate from banner
            let vc = AgahiTableViewController.create()
            vc.estateID = item.id
            show(vc, sender: nil)
        case .advertise:
            let item = self.items[indexPath.row]
            // estate from bottom
            let vc = AgahiTableViewController.create()
            vc.estateID = item.id
            show(vc, sender: nil)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // paggination
    }
}

extension HomeViewController: LoveDelegate {
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
}

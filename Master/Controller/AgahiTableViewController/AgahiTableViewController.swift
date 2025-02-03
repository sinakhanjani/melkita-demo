//
//  AgahiTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 3/28/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI
import MapKit

class AgahiTableViewController: UITableViewController {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tozihatLabel: UILabel!
    @IBOutlet weak var VijegiLabel: UILabel!
    @IBOutlet weak var qeymatForoshLabel: UILabel!
    @IBOutlet weak var qeymatEjareLabel: UILabel!
    @IBOutlet weak var qeymatRahnLabel: UILabel!
    @IBOutlet weak var otaqLabel: UILabel!
    @IBOutlet weak var sakhtLabel: UILabel!
    @IBOutlet weak var metrajLabel: UILabel!
    @IBOutlet weak var onvanLabel: UILabel!
    @IBOutlet weak var noeDasteBandiLabel: UILabel!
    @IBOutlet weak var noeAgahiLabel: UILabel!
    @IBOutlet weak var vaziyatForoshLabel: UILabel!
    @IBOutlet weak var ostanLabel: UILabel!
    @IBOutlet weak var tedadLabel: UILabel!
    @IBOutlet weak var shahrLabel: UILabel!
    @IBOutlet weak var codeAgahiLabel: UILabel!
    
    @IBOutlet weak var moqeyatLabel: UILabel!
    @IBOutlet weak var sazeLabel: UILabel!
    @IBOutlet weak var sanadLabel: UILabel!
    @IBOutlet weak var namaLabel: UILabel!
    
    private let locationManager = CLLocationManager()
    var myLocation: CLLocationCoordinate2D?

    var estateID: String?
    var agahiModel: AgahiModel?
    var rcPaymentModel: RCPaymentModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        backBarButtonAttribute(color: .black, name: "")
        // force right to left navigation.
        self.navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
        if let id = estateID {
            fetch(id: id)
            givePhoneNumberRquest(id: id)
        }
        title = "جزئیات آگهی"
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        self.collectionView.isPagingEnabled = true
        
        configurationMap()
        configBarButtons()
    }
    
    func configBarButtons() {
        let favBarButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favButtonTapped))
        favBarButton.tintColor = .black
        let reportBarButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(reportButtonTapped))
        reportBarButton.tintColor = .black
        //star
        navigationItem.rightBarButtonItems = [favBarButton, reportBarButton]
    }

    func updateUI(agahiModel: AgahiModel?) {
        self.sanadLabel.text = agahiModel?.buildingDocument?.title
        self.sazeLabel.text = agahiModel?.buildingStructureType?.title

        let a1 = agahiModel?.buildingPositionEstate.map { $0.map { $0.buildingPosition?.title ?? "" }}
        let finalA1 = a1?.filter { $0 != "" } ?? []
        if !finalA1.isEmpty {
            let a1Text = finalA1.joined(separator: ", ")
            self.moqeyatLabel.text = a1Text
        } else {
            self.moqeyatLabel.text = "-"
        }
        
        let b1 = agahiModel?.viewTypeBuildingEstate.map { $0.map { $0.viewTypeBuilding?.title ?? "" }}
        let finalB1 = b1?.filter { $0 != "" } ?? []
        if !finalB1.isEmpty {
            let B1Text = finalB1.joined(separator: ", ")
            self.namaLabel.text = B1Text
        } else {
            self.namaLabel.text = "-"
        }

        self.codeAgahiLabel.text = "\(agahiModel?.key ?? 0)"
        self.tedadLabel.text = "\(agahiModel?.visitCount ?? 0)"
        self.ostanLabel.text = "\(agahiModel?.province?.name ?? "")"
        self.shahrLabel.text = "\(agahiModel?.city?.name ?? "")"
        if agahiModel?.isMortgage ?? false {
            self.noeAgahiLabel.text = "اجاره و رهن"
        } else {
            self.noeAgahiLabel.text = "فروش"
        }
        noeDasteBandiLabel.text = (agahiModel?.useTypeEstate?.title ?? "") + " " + (agahiModel?.estateType?.title ?? "")
        onvanLabel.text = agahiModel?.title ?? ""
        self.otaqLabel.text = "\(agahiModel?.countRoom ?? 0)"
        self.sakhtLabel.text = "\((agahiModel?.isNewAge ?? false) ? "نوبنا":"قدیمی")"
        self.metrajLabel.text = "\(agahiModel?.metr ?? 0)"
        
        if let price = agahiModel?.priceMortgage {
            if price <= 0 {
                self.qeymatEjareLabel.text = "توافقی"
            } else {
                self.qeymatEjareLabel.text = "\(price.seperateByCama)" + " " + "تومان"
            }
        } else {
            self.qeymatEjareLabel.text = "توافقی"
        }
        if let price = agahiModel?.priceRent {
            if price <= 0 {
                self.qeymatEjareLabel.text = "توافقی"
            } else {
                self.qeymatRahnLabel.text = "\(price.seperateByCama)" + " " + "تومان"
            }
        } else {
            self.qeymatEjareLabel.text = "توافقی"
        }
        if let price = agahiModel?.priceBuy {
            if price <= 0 {
                self.qeymatEjareLabel.text = "توافقی"
            } else {
                self.qeymatForoshLabel.text = "\(price.seperateByCama)" + " " + "تومان"
            }
        } else {
            self.qeymatEjareLabel.text = "توافقی"
        }
        
        let vijegi = agahiModel?.features.map { $0.map { $0.feature?.title ?? "" }}
        let finalVijegi = vijegi?.filter { $0 != "" } ?? []
        let vijegiText = finalVijegi.joined(separator: ", ")
        let condition = agahiModel?.conditions.map { $0.map { $0.condition?.title ?? "" }}
        let finalCondition = condition?.filter { $0 != "" } ?? []
        let conditionText = finalCondition.joined(separator: ", ")
        self.VijegiLabel.text = vijegiText + ", " + conditionText
        
        self.tozihatLabel.text = agahiModel?.estateTypeModelDescription
        self.addressLabel.text = agahiModel?.address
        
        if let lat = agahiModel?.latitude, let long = agahiModel?.longitude {
            let locaiton = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
            mapView.centerToLocation(locaiton, regionRadius: 2000)
        }
    }
    
    func fetch(id: String) {
        startIndicatorAnimate()
        RestfulAPI<Empty,AgahiModel>.init(path: "/Estate/\(id)")
            .with(method: .GET)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.agahiModel = res
                        self.updateUI(agahiModel: res)
                        self.collectionView.reloadData()
                        break
                    case .failure(let err):
                        print(err)
                    }
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
    
    func givePhoneNumberRquest(id: String) {
        RestfulAPI<Empty,RCPaymentModel>.init(path: "/Estate/phone/\(id)")
            .with(auth: .user)
            .with(method: .GET)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.rcPaymentModel = res
                        self.tableView.reloadData()
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
    }
    
    @objc func reportButtonTapped() {
        if Authentication.user.isLogin {
            let vc = ReportViewController.create()
            vc.key = agahiModel?.key
            vc.id = agahiModel?.id
            
            present(vc, animated: true, completion: nil)
        } else {
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    @objc func favButtonTapped() {
        if Authentication.user.isLogin {
            if let id = self.agahiModel?.id {
                saveRequest(id: id)
            }
        } else {
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    @IBAction func callButtonTapped(_ sender: Any) {
        if Authentication.user.isLogin {
            if let _ = agahiModel?.id {
//                print(rcPaymentModel, agahiModel?.userID, DataManager.shared.userProfile?.data?.id)
                if agahiModel?.userID == DataManager.shared.userProfile?.data?.id {
                    let vc = AgahiDetailPersonTableViewController.create()
                    vc.rcPayment = rcPaymentModel
                    self.present(vc, animated: true, completion: nil)
                    return
                }
                if ((rcPaymentModel?.isFree ?? false) || (rcPaymentModel?.isPay ?? false)) { //
                    let vc = AgahiDetailPersonTableViewController.create()
                    vc.rcPayment = rcPaymentModel
                    self.present(vc, animated: true, completion: nil)
                } else {
                    let nav = UINavigationController.create(withId: "UINavigationControllerPayment") as! UINavigationController
                    let vc = nav.viewControllers.first as! PaymentTableViewController
                    vc.rcPayment = rcPaymentModel
                    vc.type = 1
                    vc.estateID = self.estateID
                    
                    self.present(nav, animated: true, completion: nil)
                }
            }
        } else {
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    @IBAction func chatButtonTapped(_ sender: Any) {
        // badan inja code bzan
        let vc = ChatTableViewController.create()
        vc.title = self.agahiModel?.title
        vc.receiverID = self.agahiModel?.userID
        
        show(vc, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let agahiModel = self.agahiModel {
            if (agahiModel.isMortgage ?? false) {
                if indexPath.section == 4 {
                    return 0
                }
            } else {
                if indexPath.section == 3 {
                    return 0
                }
            }
        }
        
        if indexPath.section == 5 {
            if (rcPaymentModel?.isPay ?? false) {
                return 90
            } else {
                return 0
            }
        }
        
        if indexPath.section == 6 {
            if agahiModel?.videoURL == nil {
                return 0
            }
        }
        
        if indexPath.section == 7 {
            if let _ = agahiModel?.latitude, let _ = agahiModel?.longitude, (rcPaymentModel?.isPay ?? false) {
                return 240
            } else {
                return 0
            }
        }
        
        if indexPath.section == 10 {
            if agahiModel?.userID != DataManager.shared.userProfile?.data?.id {
                if !(rcPaymentModel?.isPay ?? false) {
                    return 0
                }
            } else {
                return 0
            }
        }
        
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 6 {
            if let url = agahiModel?.videoURL {
                let finalStr = url
                if let finalURL = URL(string: finalStr) {
                    playVideo(url: finalURL)
                }
            }
        }
    }
}

extension AgahiTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.agahiModel?.pictures?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        if let item = self.agahiModel?.pictures?[indexPath.item] {
            cell.imageView1.loadImageUsingCache(withUrl: item.picURL ?? "")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width, height: collectionView.frame.height)
    }

}

extension AgahiTableViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    public func configurationMap() {
        mapView.delegate = self // set from storyboard in this case/.
        mapView.showsUserLocation = true
        mapView.isUserInteractionEnabled = false // DISABLE USER INTERCATION
//
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
//
//        locationManager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
}

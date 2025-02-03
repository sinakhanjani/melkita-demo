//
//  AddAgahiStep3TableViewController.swift
//  Master
//
//  Created by Sina khanjani on 4/26/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import SimpleCheckbox
import MapKit
import RestfulAPI

class AddAgahiStep3TableViewController: UITableViewController {

    @IBOutlet weak var shahrLabel: UILabel!
    @IBOutlet weak var ostanLabel: UILabel!
    @IBOutlet weak var ageTextField: InsetTextField!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var checkBox: Checkbox!

    let locationManager = CLLocationManager()
    var myLocation: CLLocationCoordinate2D?
    
    var addAgahi = AddAgahiModelBody()
    var addInfo: AddInfo?
    var cities = [City]()

    var isUpdate = false
    var updateEstateID: String?
    var agahiModel: AgahiModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationMap()
        title = "ثبت آگهی"
        addressTextView.font = UIFont.persianFont(size: 17)
        backBarButtonAttribute(color: .black, name: "")
        checkBox.valueChanged = { state in
            self.ageTextField.isEnabled = state ? false:true
            self.ageTextField.backgroundColor = state ? .darkGray:.clear
        }
        if isUpdate {
            shahrLabel.text = agahiModel?.city?.name
            ostanLabel.text = agahiModel?.province?.name
            checkBox.isChecked = agahiModel?.isNewAge ?? false
            if agahiModel?.isNewAge == true {
                ageTextField.text = ""
            }
            addressTextView.text = agahiModel?.address

            if let lat = agahiModel?.latitude, let long = agahiModel?.longitude {
                let location = CLLocation(latitude: lat, longitude: long)
                self.mapView.centerToLocation(location)
            }
            
            addAgahi.cityID = agahiModel?.city?.id
            addAgahi.provinceID = agahiModel?.province?.id
            addAgahi.isNewAge = agahiModel?.isNewAge
            addAgahi.age = agahiModel?.age
            addAgahi.address = agahiModel?.address
            addAgahi.latitude = agahiModel?.latitude
            addAgahi.longitude = agahiModel?.longitude
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
                        break
                    case .failure(_):
                        break
                    }
                }
            }
    }

    @IBAction func agreeButtonTapped(_ sender: Any) {
        guard addAgahi.provinceID != nil else {
            presentCDAlertWarningAlert(message: "لطف استان را انتخاب کنید", completion: {})
            return
        }
        guard addAgahi.cityID != nil else {
            presentCDAlertWarningAlert(message: "لطف شهر را انتخاب کنید", completion: {})
            return
        }
        guard checkBox.isChecked || (ageTextField.text!.count > 0 && Int(ageTextField.text!) != nil) else {
            presentCDAlertWarningAlert(message: "قدمت بنا را مشخص کنید", completion: {})
            return
        }
        guard addressTextView.text!.count > 10 else {
            presentCDAlertWarningAlert(message: "لطفا آدرس ملک را کامل وارد کنید", completion: {})
            return
        }
        
        if checkBox.isChecked {
            addAgahi.isNewAge = true
            addAgahi.age = 0
        } else {
            addAgahi.age = Int(ageTextField.text!)!
            addAgahi.isNewAge = false
        }
        
        addAgahi.address = addressTextView.text

        addAgahi.latitude = myLocation?.latitude
        addAgahi.longitude = myLocation?.longitude
        
        let vc = AddAgahiStep4TableViewController.create()
        vc.addInfo = addInfo
        vc.addAgahi = addAgahi
        
        vc.isUpdate = isUpdate
        vc.agahiModel = agahiModel
        vc.updateEstateID = updateEstateID
        
        show(vc, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            // ostan
            let items = addInfo?.provinces?.map { SelectionModel(id: "\($0.id ?? 0)", title: $0.name ?? "", section: .provenance)}
            let vc = SelectionTableViewController.create()
            vc.delegate = self
            vc.selectionModels = items
            show(vc, sender: nil)
        }
        if indexPath.section == 2 {
            // shahrs
            let items = cities.map { SelectionModel(id: "\($0.id ?? 0)", title: $0.name ?? "", section: .city)}
            let vc = SelectionTableViewController.create()
            vc.delegate = self
            vc.selectionModels = items
            show(vc, sender: nil)
        }
    }
}

extension AddAgahiStep3TableViewController: SelectionTableViewControllerDelegate {
    func didselectSection(item: SelectionModel) {
        if let indexPath = tableView.indexPathForSelectedRow {
            if indexPath.section == 1 {
                // ostan
                addAgahi.provinceID = Int(item.id)!
                self.ostanLabel.text = item.title
                self.fetchCity(provId: addAgahi.provinceID!)
                self.addAgahi.cityID = nil
                self.shahrLabel.text = "شهر را انتخاب کنید"
                
                let index = addInfo?.provinces?.firstIndex(where: { i in
                    i.id == Int(item.id)!
                })
                if let index = index {
                    if let item = addInfo?.provinces?[index] {
                        mapView.centerToLocation(CLLocation(latitude: item.latitude ?? 0.0, longitude: item.longitude ?? 0.0), regionRadius: 10000)
                    }
                }
            }
            
            if indexPath.section == 2 {
                // shahrs
                self.shahrLabel.text = item.title
                addAgahi.cityID = Int(item.id)!
            }
        }
    }
}

extension AddAgahiStep3TableViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    public func configurationMap() {
        mapView.delegate = self // set from storyboard in this case/.
        mapView.showsUserLocation = true
//
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
//
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.mapView.centerToLocation(location)
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let mapLatitude = mapView.centerCoordinate.latitude
        let mapLongitude = mapView.centerCoordinate.longitude
        self.myLocation = CLLocationCoordinate2D(latitude: mapLatitude, longitude: mapLongitude)
    }
}

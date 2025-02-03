//
//  MapViewController.swift
//  Master
//
//  Created by Sina khanjani on 3/3/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate {
    func coordinate(_ data: CLLocationCoordinate2D)
}

class MapViewController: AppViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var centerLocation: CLLocationCoordinate2D?
    
    var delegate:MapViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }

        if let userLocation = locationManager.location?.coordinate {
            self.centerLocation = userLocation
            let location = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            mapView.centerToLocation(location, regionRadius: 300)
        }
        
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func mapCenterButtonTapped(_ sender: Any) {
        if let centerLocation = self.centerLocation {
            delegate?.coordinate(centerLocation)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        let location = locations.last as! CLLocation
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//        region.center = mapView.userLocation.coordinate
//        self.centerLocation = locations.first?.coordinate
//        mapView.setRegion(region, animated: true)
//        if let centerLocation = self.centerLocation {
//            delegate?.coordinate(centerLocation)
//        }
//        print("HEREEEEEEE1")
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        self.centerLocation = locations.first?.coordinate
//        if let centerLocation = self.centerLocation {
//            delegate?.coordinate(centerLocation)
//        }
//        print("HEREEEEEee2")
    }
    
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        print("HERE3")
//    }
//
//    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
//        print("HEREE4")
//    }
//
//    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
//        print("HEREE5")
//    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.centerLocation = mapView.centerCoordinate
        if let centerLocation = self.centerLocation {
            delegate?.coordinate(centerLocation)
        }
        print("HERE 6", mapView.centerCoordinate)
    }
}

public extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)

        setRegion(coordinateRegion, animated: true)
        
        let mapCamera = MKMapCamera(lookingAtCenter: coordinateRegion.center, fromDistance: regionRadius, pitch: 0, heading: 0)
        
        self.setCamera(mapCamera, animated: true)
    }
}

//
//  sampleCode.swift
//  Master
//
//  Created by Sina khanjani on 6/16/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import Foundation

//// ---- WITH FLOWLAYOUT ----
//@IBOutlet weak var collectionView: UICollectionView!
//collectionView.collectionViewLayout = CoWorkerCollectionViewFlowLayout(itemSize: CGSize(<#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>));
//collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
//extension : UICollectionViewDataSource, UICollectionViewDelegate {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath) as! CollectionViewCell
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
//
//
//}




//// ---- PAGING FLOWLAYOUT ----
//@IBOutlet weak var collectionView: UICollectionView!
//let layout = UICollectionViewFlowLayout()
//layout.scrollDirection = .horizontal
//self.collectionView.collectionViewLayout = layout
//self.collectionView.isPagingEnabled = true
//@IBOutlet weak var collectionView: UICollectionView!
//extension : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath) as! CollectionViewCell
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize.init(width: collectionView.frame.width, height: collectionView.frame.height)
//    }
//
//}





//// ---- WITH FLOWLAYOUT ----
//@IBOutlet weak var collectionView: UICollectionView!
//extension : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath) as! CollectionViewCell
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var numberOfColumns: CGFloat = 3
//        if UIScreen.main.bounds.width > 320 {
//            numberOfColumns = 2
//        }
//        let spaceBetweenCells: CGFloat = 10
//        let padding: CGFloat = 40
//        let cellDimention = ((collectionView.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns
//
//        return CGSize.init(width: cellDimention, height: cellDimention)
//
//    }
//
//}




//// ---- WITHOUT FLOWLAYOUT ----
//@IBOutlet weak var collectionView: UICollectionView!
//extension : UICollectionViewDataSource, UICollectionViewDelegate {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath) as! CollectionViewCell
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //
//    }
//
//}




//// ---- STATUSBAR ----
//override var preferredStatusBarStyle: UIStatusBarStyle {
//    return .lightContent
//}




//// ---- TEXTFIELD ----
//func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//    var maxLength = 0
//    let currentString: NSString = textField.text! as NSString
//    let newString: NSString =
//        currentString.replacingCharacters(in: range, with: string) as NSString
//    maxLength = 20
//    return newString.length <= maxLength
//}
//
//func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//    textField.text = ""
//
//    return true
//}
//func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    self.view.endEditing(true)
//
//    return true
//}





//// ---- PRESENT ----
//static func create() ->  {
//    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//    let vc = mainStoryboard.instantiateViewController(withIdentifier: String(describing: self)) as!
////    vc.modalTransitionStyle =
////    vc.modalPresentationStyle =
//    return vc
//}





//// ---- TIMER ----
//private var timer: Timer?
//private var elapsedTimeInSecond: Int = 60
//
//private func startTimer() {
//    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
//        self.elapsedTimeInSecond -= 1
//        self.updateTimeLabel()
//        if self.elapsedTimeInSecond == 0 {
//            self.pauseTimer()
//        }
//    })
//}
//
//private func resetTimer() {
//    timer?.invalidate()
//    elapsedTimeInSecond = 60
//    updateTimeLabel()
//}
//
//private func pauseTimer() {
//    timer?.invalidate()
//}
//
//private func updateTimeLabel() {
//    let seconds = elapsedTimeInSecond % 60
//    let text = String(format: "%02d",seconds)
//    timeLabel.text = text
//}



//// ---- KEYBOARD FOR SCROLL ----
//extension  {
//
//    func addKeyboardNotification() {
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    @objc func keyboardDidShow(notification: NSNotification) {
//        var info = notification.userInfo
//        let keyBoardSize = info![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//        scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height, right: 0.0)
//        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height, right: 0.0)
//    }
//
//    @objc func keyboardDidHide(notification: NSNotification) {
//        scrollView.contentInset = UIEdgeInsets.zero
//        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
//    }
//
//}




//// ---- POPOVER ----

//private var completionHandler: (() -> Void)?
//extension : UIPopoverPresentationControllerDelegate {
//
//    func presentPopoverConroller(toView view: UIView, direction: UIPopoverArrowDirection, title: String?, description: String?, height: CGFloat?, completionHandler: (() -> Void)?) {
//        let key = "registerLocationKey"
//        guard !UserDefaults.standard.bool(forKey: key) else { return }
//        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopoverViewController") as! PopoverViewController
//        popController.infromation = description
//        popController.subject = title
//        popController.preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 64.0, height: height ?? 180)
//        popController.modalPresentationStyle = UIModalPresentationStyle.popover
//        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
//        popController.popoverPresentationController?.delegate = self
//        popController.popoverPresentationController?.sourceView = view
//        popController.popoverPresentationController?.sourceRect = view.bounds
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
//            self.present(popController, animated: true) {
//                UserDefaults.standard.set(true, forKey: key)
//                self.completionHandler = completionHandler
//            }
//        }
//    }
//
//    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
//        completionHandler?()
//    }
//
//    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return .none
//    }
//
//    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
//        return UIModalPresentationStyle.none
//    }
//
//    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
//        return UIModalPresentationStyle.none
//    }
//
//
//}



//
//import CoreMedia
//import AVFoundation
//class TEST: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//
//    let imagePicker = UIImagePickerController()
//    var videoData = Data()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        imagePicker.delegate = self
//        //
//    }
//
//    @IBAction func buttonTapped(_ sender: Any) {
//        //PHOTO GALLERY IMAGE
//        self.imagePicker.sourceType = .photoLibrary
//        self.imagePicker.mediaTypes = ["public.image"]
//
//        //MOVIE GALLERY IMAGE
//        self.imagePicker.mediaTypes = ["public.movie"]
//
//        // BOTH
//        self.imagePicker.mediaTypes = ["public.movie","public.image"]
//        self.present(self.imagePicker, animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let mediaTypeImport = info[UIImagePickerController.InfoKey.mediaType] as? String {
//            if mediaTypeImport  == "public.image" {
//                if let image = info[.originalImage] as? UIImage {
//                    ////
//                }
//            }
//            if mediaTypeImport == "public.movie" {
//                guard let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
//                let duration = CMTimeGetSeconds(AVAsset(url: videoURL).duration)
//                guard duration <= 60 else {
//                    // 'WARNING'
//                    return
//                }
//                let video = try? Data(contentsOf: videoURL, options: .mappedIfSafe)
//                guard let safeVideo = video else { self.dismiss(animated: true, completion: nil) ; return }
//                guard safeVideo.count >= 15000000 else {
//                    // 'WARNING'
//                    return
//                }
//                self.videoData = safeVideo
//                ///////
//            }
//        }
//        self.dismiss(animated: true, completion: nil)
//    }
//
//
//}

//import GoogleMaps
//import GooglePlaces
//class TEST:UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
//
//    @IBOutlet weak var mapView: GMSMapView!
//
//    var locationManager = CLLocationManager()
//    var centerMapCoordinate = CLLocationCoordinate2D()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        updateUI()
//    }
//
//    func updateUI() {
//        locationManagerDelegateSetting()
//        //
//    }
//
//    func locationManagerDelegateSetting() {
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//        mapView.isMyLocationEnabled = true
//        mapView.delegate = self
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation: CLLocation = locations[0]
//        let geoLong = userLocation.coordinate.longitude
//        let geoLat = userLocation.coordinate.latitude
//        let camera = GMSCameraPosition.camera(withLatitude: geoLat, longitude: geoLong, zoom: 16)
//        mapView.camera = camera
//        self.centerMapCoordinate = CLLocationCoordinate2D(latitude: geoLat, longitude: geoLong)
//        locationManager.stopUpdatingLocation()
//    }
//
//    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        let latitude = mapView.camera.target.latitude
//        let longitude = mapView.camera.target.longitude
//        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    }
//
//
//}

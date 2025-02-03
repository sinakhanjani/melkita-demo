//
//  UIViewControllerExtension.swift
//  Master
//
//  Created by Sinakhanjani on 10/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import AVFoundation
import CDAlertView
import MaterialShowcase
import SideMenu
import Lottie
import AVKit
import AVFoundation

extension UIViewController {
    public static func create () -> Self {
        return create(type: self)
    }
    public class func create<T : UIViewController> (type: T.Type) -> T  {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : T = mainStoryboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
        
        return vc
    }
    
    static func create (withId id : String) -> UIViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: id)
        
        return vc
    }
}

extension UIViewController {
    
    func backBarButtonAttribute(color: UIColor, name: String) {
        let backButton = UIBarButtonItem(title: name, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.persianFont(size: 15)], for: .normal)
        backButton.tintColor = color
        navigationItem.backBarButtonItem = backButton
    }
    
}

// MENU ANIMATION
extension UIViewController {
    
    func showAnimate() {
        self.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.4) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    func removeAnimate(boxView: UIView? = nil) {
        if let boxView = boxView {
            self.sideHideAnimate(view: boxView)
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            self.view.alpha = 0.0
        }) { (finished) in
            if finished {
                self.view.removeFromSuperview()
            }
        }
    }
    
    func sideShowAnimate(view: UIView) {
        view.transform = CGAffineTransform.init(translationX: UIScreen.main.bounds.width, y: 0)
        UIView.animate(withDuration: 1.4) {
            view.transform = CGAffineTransform.identity
        }
    }
    
    func sideHideAnimate(view: UIView) {
        UIView.animate(withDuration: 1.4, animations: {
            view.transform = CGAffineTransform.init(translationX: UIScreen.main.bounds.width, y: 0)
        }) { (finished) in
            if finished {
                //
            }
        }
    }
    
}

extension UIViewController {
    
//    func presentMenuViewController() {
//        let vc =
//        self.addChild(vc)
//        vc.view.frame = self.view.frame
//        self.view.addSubview(vc.view)
//        vc.didMove(toParent: self)
//    }
    


    
}

extension UIViewController {
    
    func startIndicatorAnimate() {
        let vc = IndicatorViewController()
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    func stopIndicatorAnimate() {
        NotificationCenter.default.post(name: Constant.Notify.dismissIndicatorViewControllerNotify, object: nil)
    }
    
}

extension UIViewController {
    
    func presentIOSAlertWarning(message: String, completion: @escaping () -> Void) {
        let title = NSAttributedString(string: "توجه", attributes: [NSAttributedString.Key.font : UIFont.init(name: Constant.Fonts.fontOne, size: 15.0)!, NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.08911790699, green: 0.08914073557, blue: 0.08911494166, alpha: 1)])
        let attributeMsg = NSAttributedString(string: message, attributes: [NSAttributedString.Key.font : UIFont.init(name: Constant.Fonts.fontOne, size: 13.0)!, NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        
        let alertController = UIAlertController(title: "توجه !", message: message, preferredStyle: .alert)
        alertController.setValue(attributeMsg, forKey: "attributedMessage")
        alertController.setValue(title, forKey: "attributedTitle")
        let doneAction = UIAlertAction.init(title: "باشه", style: .cancel) { (action) in
            completion()
        }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentIOSAlertWarningWithTwoButton(message: String, buttonOneTitle: String, buttonTwoTitle: String, handlerButtonOne: @escaping () -> Void, handlerButtonTwo: @escaping () -> Void) {
        let title = NSAttributedString(string: "توجه", attributes: [NSAttributedString.Key.font : UIFont.init(name: Constant.Fonts.fontOne, size: 15.0)!, NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.08911790699, green: 0.08914073557, blue: 0.08911494166, alpha: 1)])
        let attributeMsg = NSAttributedString(string: message, attributes: [NSAttributedString.Key.font : UIFont.init(name: Constant.Fonts.fontOne, size: 13.0)!, NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        
        let alertController = UIAlertController(title: "توجه !", message: message, preferredStyle: .alert)
        alertController.setValue(attributeMsg, forKey: "attributedMessage")
        alertController.setValue(title, forKey: "attributedTitle")
        let doneAction1 = UIAlertAction.init(title: buttonOneTitle, style: .default) { (action) in
            handlerButtonOne()
        }
        let doneAction2 = UIAlertAction.init(title: buttonTwoTitle, style: .default) { (action) in
            handlerButtonTwo()
        }
        alertController.addAction(doneAction1)
        alertController.addAction(doneAction2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentCDAlertWarningAlert(message: String, completion: @escaping () -> Void) {
        let alert = CDAlertView(title: "توجه", message: message, type: CDAlertViewType.notification)
        alert.titleFont = UIFont(name: Constant.Fonts.fontOne, size: 15)!
        alert.messageFont = UIFont(name: Constant.Fonts.fontOne, size: 13)!
        let done = CDAlertViewAction.init(title: "باشه", font: UIFont(name: Constant.Fonts.fontOne, size: 15)!, textColor: UIColor.darkGray, backgroundColor: .white) { (alert) -> Bool in
            completion()
            return true
        }
        alert.add(action: done)
        alert.show()
    }
    
    func presentCDAlertWarningWithTwoAction(message: String, buttonOneTitle: String, buttonTwoTitle: String, handlerButtonOne: @escaping () -> Void, handlerButtonTwo: @escaping () -> Void) {
        
        let alert = CDAlertView(title: "توجه", message: message, type: CDAlertViewType.notification)
        alert.titleFont = UIFont(name: Constant.Fonts.fontOne, size: 15)!
        alert.messageFont = UIFont(name: Constant.Fonts.fontOne, size: 13)!
        let buttonOne = CDAlertViewAction.init(title: buttonOneTitle, font: UIFont(name: Constant.Fonts.fontOne, size: 15)!, textColor: UIColor.darkGray, backgroundColor: .white) { (alert) -> Bool in
            handlerButtonOne()
            return true
        }
        let buttonTwo = CDAlertViewAction.init(title: buttonTwoTitle, font: UIFont(name: Constant.Fonts.fontOne, size: 15)!, textColor: UIColor.darkGray, backgroundColor: .white) { (alert) -> Bool in
            handlerButtonTwo()
            return true
        }
        alert.add(action: buttonOne)
        alert.add(action: buttonTwo)
        alert.show()
    }
    
    func phoneNumberCondition(phoneNumber number: String) -> Bool {
        guard !number.isEmpty else {
            let message = "شماره همراه خالی میباشد !"
            presentCDAlertWarningAlert(message: message, completion: {})
            return false
        }
        let startIndex = number.startIndex
        let zero = number[startIndex]
        guard zero == "0" else {
            let message = "شماره همراه خود را با صفر وارد کنید !"
            presentCDAlertWarningAlert(message: message, completion: {})
            return false
        }
        guard number.count == 11 else {
            let message = "شماره همراه میبایست یازده رقمی باشد !"
            presentCDAlertWarningAlert(message: message, completion: {})
            return false
        }
        
        return true
    }
    
}

extension UIViewController {
    //
}

extension UIViewController: MaterialShowcaseDelegate {
    
    func showCase(view: UIView, header: String, text: String) {
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: view) // always required to set targetView
        let customColor = UIColor(red: 23/255.0, green: 25/255.0, blue: 112/255.0, alpha: 1.0)
        showcase.primaryTextAlignment = .right
        showcase.secondaryTextAlignment = .right
        showcase.targetHolderRadius = view.frame.height
        showcase.backgroundViewType = .circle
        showcase.backgroundPromptColor = customColor
        showcase.targetHolderColor = .clear
        showcase.primaryText = header
        showcase.secondaryText = text
        showcase.show(completion: {
            // You can save showcase state here
            // Later you can check and do not show it again
        })
        showcase.delegate = self
    }
    
    
}

extension UIViewController {
    
    func configureTouchXibViewController(bgView: UIView) {
        self.view.endEditing(true)
        let touch = UITapGestureRecognizer(target: self, action: #selector(dismissTouchPressed))
        bgView.addGestureRecognizer(touch)
    }
    
    @objc func dismissTouchPressed() {
        removeAnimate()
    }

    func configureTouchXibByPresentViewController(bgView: UIView) {
        let touch = UITapGestureRecognizer(target: self, action: #selector(dismissPresentTouchPressed))
        bgView.addGestureRecognizer(touch)
    }
    
    @objc private func dismissPresentTouchPressed() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UIViewController {
    
    func loadLottieJson(bundleName name: String, lottieView: UIView) {
        // Create Boat Animation
        let boatAnimation = AnimationView(name: name)
        // Set view to full screen, aspectFill
        boatAnimation.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        boatAnimation.contentMode = .scaleAspectFill
        boatAnimation.frame = lottieView.bounds
        // Add the Animation
        lottieView.addSubview(boatAnimation)
        boatAnimation.loopMode = .loop
        boatAnimation.play()
    }
    
//    func loadLottieFromURL(url: URL?, lottieView: UIView) {
//        // Create Boat Animation
//        guard let url = url else { return }
//        let boatAnimation = AnimationView.init(url: url) { (err) in
//            //
//        }
//        // Set view to full screen, aspectFill
//        boatAnimation.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        boatAnimation.contentMode = .scaleAspectFill
//        boatAnimation.frame = lottieView.bounds
//        // Add the Animation
//        lottieView.addSubview(boatAnimation)
//        boatAnimation.loopMode = .loop
//        boatAnimation.play()
//    }
    
}

extension UIViewController {
    
    func configureSideBar() {
        // Define the menus
        SideMenuManager.default.rightMenuNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as? SideMenuNavigationController
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }
    
    func toggleSideMenu() {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let sideNav = mainStoryboard.instantiateViewController(withIdentifier: "RightMenuNavigationController") as! SideMenuNavigationController
        sideNav.settings = sideSetting()
        self.present(sideNav, animated: true, completion: nil)
    }
    
    private func sideSetting() -> SideMenuSettings {
        let presentationStyle = SideMenuPresentationStyle.menuSlideIn
        presentationStyle.backgroundColor = .white
        presentationStyle.menuStartAlpha = 1.0
        presentationStyle.menuScaleFactor = 1.0
        presentationStyle.onTopShadowOpacity = 0.7
        presentationStyle.presentingEndAlpha = 1.0
        presentationStyle.presentingScaleFactor = 1.0
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = (UIScreen.main.bounds.width/3)*2
        let styles:[UIBlurEffect.Style?] = [nil, .dark, .light, .extraLight]
        settings.blurEffectStyle = styles[1]
        settings.statusBarEndAlpha = 0
        
        return settings
    }
    
    
}

extension UIViewController: AVPlayerViewControllerDelegate {
    func playVideo(url: URL) {
        let player = AVPlayer.init(url: url)
        let playerController = AVPlayerViewController()
        playerController.delegate = self
        playerController.player = player
        //self.addChildViewController(playerController)
        //self.view.addSubview(playerController.view)
        //playerController.view.frame = self.view.frame
        present(playerController, animated: true, completion: nil)
        player.play()
    }
}

extension UIViewController {
    
    func addChangedLanguagedToViewController() {
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: Constant.Notify.LanguageChangedNotify, object: nil)
        
    }
    
    @objc private func languageChanged() {
        for view in view.subviews {
            view.setNeedsDisplay()
            view.setNeedsLayout()
            view.layoutIfNeeded()
            view.updateFocusIfNeeded()
            view.updateConstraintsIfNeeded()
            view.reloadInputViews()
        }
        loadViewIfNeeded()
    }
    
    
}

extension UIViewController {
    
    func shareInSocial(activityItems:[UIActivity]) {
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }

}
extension UIViewController {
    func registerTableViewCell(tableView: UITableView, cell: UITableViewCell.Type) {
        let nib = UINib(nibName: cell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cell.identifier)
    }
    
    func registerCollectionViewCell(collectionView: UICollectionView, cell: UICollectionViewCell.Type) {
        let nib = UINib(nibName: cell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cell.identifier)
    }
}
extension UICollectionViewCell {
    //The @objc is added to silence the complier errors
    @objc class var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell {
    //The @objc is added to silence the complier errors
    @objc class var identifier: String {
        return String(describing: self)
    }
}


//
//  AppViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/27/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

class AppViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        backBarButtonAttribute(color: .black, name: "")
        // force right to left navigation.
        self.navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
    }
    
    func customizeNavigationAndTabView() {
        let customNavView = UIView.init(frame: CGRect.init(0, 0, 120, 50))
        customNavView.backgroundColor = .clear
        let label = UILabel.init(frame: CGRect.init(0, 0, 120, 50))
        label.font = UIFont.init(name: Constant.Fonts.casablancaRegular, size: 20)!
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = ""
        customNavView.addSubview(label)
        navigationItem.titleView = customNavView
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.persianFont(size: 17),NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        // add yellow Line To NavigationController
        guard let _ = self.navigationController else { return }
        let yellowView = UIView(frame: CGRect(x: 0, y: navigationController!.navigationBar.bounds.height, width: UIScreen.main.bounds.width, height: 0.5))
        yellowView.backgroundColor = #colorLiteral(red: 0.7625358701, green: 0.5855332017, blue: 0.1807247698, alpha: 1)
        navigationController?.navigationBar.addSubview(yellowView)
        // add Line to TabBarController
        let tabBarLine = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.5))
        tabBarLine.backgroundColor = #colorLiteral(red: 0.7625358701, green: 0.5855332017, blue: 0.1807247698, alpha: 1)
        tabBarController?.tabBar.addSubview(tabBarLine)
        //
    }
    
    

}

//
//  ViewController.swift
//  Master
//
//  Created by Sinakhanjani on 10/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import  RestfulAPI

class LoaderViewController: UIViewController {
    
    fileprivate let dispathGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //
        dispathGroup.notify(queue: .main) {
            print("COMPLETE FETCH ALL DATA")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.performSegue(withIdentifier: "toTabBarSegue", sender: nil)
        }
    }
    
    // Method
    func updateUI() {
        // refreshToken here:
        if Authentication.user.isLogin {
            RestfulAPI<RefreshTokenSend,RefreshTokenRecieved>.init(path: "/Auth/refresh-token")
                .with(auth: .user)
                .with(method: .POST)
                .with(body: RefreshTokenSend(refreshToken: DataManager.shared.refreshToken ?? ""))
                .sendURLSessionRequest { (result) in
                    switch result {
                    case .success(let res):
                        if res.isSuccess {
                            DataManager.shared.refreshToken = res.refreshToken
                            var user = Authentication.user
                            user.register(with: res.accessToken)
                        }
                    case .failure(_):
                        break
                    }
                }
        }
    }

    @IBAction func unwindToLoaderViewController(_ segue: UIStoryboardSegue) {
        //
    }
}


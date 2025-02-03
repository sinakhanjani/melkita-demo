//
//  KharidEshterakTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/23/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class KharidEshterakTableViewController: UITableViewController, TableViewCellDelegate {
    
    var items = [SinglePackage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .black, name: "")
        title = "خرید اشتراک"
        fetchPackages()
    }
    
    func fetchPackages() {
        RestfulAPI<Empty,[SinglePackage]>.init(path: "/Marketer/register-package")
        .with(auth: .user)
        .with(method: .GET)
        .with(queries: ["Page":"1", "PageSize":"10000"])
        .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let res):
                    self.items = res
                    self.tableView.reloadData()
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    func buyFree(id: String) {
        struct Send: Codable { let id: String }
        RestfulAPI<Send,GenericOrginal<Empty>>.init(path: "/Marketer/register-package/active")
        .with(auth: .user)
        .with(method: .POST)
            .with(body: Send(id: id))
        .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let res):
                    if res.isSuccess == true {
                        DispatchQueue.main.async {
                            self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                    self.tableView.reloadData()
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    func openPaymentVC(price: Int?, offPrice: Int?, packageId: String) {
        let nav = UINavigationController.create(withId: "UINavigationControllerPayment") as! UINavigationController
        let vc = nav.viewControllers.first as! PaymentTableViewController
        vc.type = 8
        vc.rcPayment = RCPaymentModel(price: price, discountPrice: offPrice)
        vc.packageId = packageId

        present(nav, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.delegate = self
        
        let item = items[indexPath.item]
        cell.titleLabel1.text = "اشتراک \(item.expireDays ?? 0) بازاریابان"
        cell.titleLabel2.text = (item.price?.seperateByCama ?? "") + " تومان"
        cell.titleLabel3.text = "انقضاء \(item.expireDays ?? 0) روز"
        
        return cell
    }
    
    func button1Tapped(sender: UIButton, cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let item = items[indexPath.item]
            
            if item.isFree == true {
                self.buyFree(id: item.id!)
            } else {
                openPaymentVC(price: item.price, offPrice: nil, packageId: item.id!)
            }
        }
    }
}

// MARK: - SinglePackage
struct SinglePackage: Codable {
    let id, title: String?
    let expireDays, price: Int?
    let isFree: Bool?
    let daysAfterExpire: Int?
}

//
//  PardakhtiManTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class PardakhtiManTableViewController: UITableViewController {

    var queries: [String:String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .black, name: "")
        if let queries = queries {
            self.fetch(query: queries)
        } else {
            self.fetch(query: [:])
        }
    }
    
    var items = [RCPardakhti]()
    
    func fetch(query: [String:String]) {
        var all:[String:String] = queries ?? [:]
        all.updateValue("1", forKey: "Page")
        all.updateValue("1000", forKey: "PageSize")
        RestfulAPI<Empty,[RCPardakhti]>.init(path: "/User/orders")
        .with(auth: .user)
        .with(method: .GET)
            .with(queries: all)
        .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                self.stopIndicatorAnimate()
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
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        let vc = SearchPardakhtiTableViewController.create()
        vc.delegate = self
        show(vc, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        let item = items[indexPath.item]
        cell.titleLabel1.text = item.paymentDate?.persianDateWithFormat("YYYY/MM/dd")
        cell.titleLabel2.text = item.paymentDate?.persianDateWithFormat("hh:mm")
        cell.titleLabel3.text = (item.price?.seperateByCama ?? "0") + " تومان"
        cell.titleLabel4.text = (item.priceEnd?.seperateByCama ?? "0") + " تومان"
        cell.titleLabel5.text = item.rsBankDescription
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nc = segue.destination as? UINavigationController {
            if let vc = nc.viewControllers.first as? PardakhtiDetailTableViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    vc.id = items[indexPath.item].id
                }
            }
        }
    }
}

extension PardakhtiManTableViewController: SearchPardakhtiTableViewControllerDelegate {
    func addSearchQuery(_ dict: [String : String]) {
        self.fetch(query: dict)
    }
}

// MARK: - RSBankElement
struct RCPardakhti: Codable {
    let id: String
    let price, priceEnd: Int?
    let rsBankDescription, trackingCode, paymentDate, bank: String?
    let isMobile: Bool?
    let userID: String?

    enum CodingKeys: String, CodingKey {
        case id, price, priceEnd
        case rsBankDescription = "description"
        case trackingCode, paymentDate, bank, isMobile
        case userID = "userId"
    }
}

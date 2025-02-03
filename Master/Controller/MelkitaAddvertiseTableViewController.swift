//
//  MelkitaAddvertiseTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/13/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI
import MapKit

class MelkitaAddvertiseTableViewController: UITableViewController {
    
    var items = [AdvertiseElement]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "تبلیغات ملکیتا"
        backBarButtonAttribute(color: .black, name: "")
        fetch()
    }
    
    func fetch() {
        RestfulAPI<EMPTYMODEL,[AdvertiseElement]>.init(path: "/Common/advertising")
        .with(auth: .user)
        .with(queries: ["Page":"1", "PageSize":"10000"])
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.delegate = self
        let item = items[indexPath.item]
        if let picURL = item.picURL {
            let ext = picURL.split(separator: ".")[1]
            let strExt = String(ext)
            print(strExt)
            if strExt == "gif" {
                cell.imageView1.image = UIImage.gifImageWithURL("https://www.melkita.com"+picURL)
            } else {
                cell.imageView1.loadImageUsingCache(withUrl: picURL)
            }
        }
        
        cell.titleLabel1.text = item.title
        cell.titleLabel2.text = item.phoneNumber
        cell.titleLabel3.text = item.advertiseDescription
        cell.button1.setTitle(item.linkURL ?? "", for: .normal)
        cell.button2.setTitle(item.instagramPage ?? "", for: .normal)
        // iamgeView1 ax
        // label1 melkita
        // label2 = phone
        // label 3 = tozihat
        
        // button1 = link site
        // button2 instagram
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = items[indexPath.item].height {
            
            return CGFloat(height+240)
        }
        
        return UITableView.automaticDimension
    }
    
    func open(name: String) {
        if let url = URL(string: name), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

extension MelkitaAddvertiseTableViewController: TableViewCellDelegate {
    func button1Tapped(sender: UIButton, cell: TableViewCell) {
        // site
        if let indexPath = tableView.indexPath(for: cell) {
            let item = items[indexPath.item]
            if let link = item.linkURL {
                open(name: link)
            }
        }
    }
    
    func button2Tapped(sender: UIButton, cell: TableViewCell) {
        // insta
        if let indexPath = tableView.indexPath(for: cell) {
            let item = items[indexPath.item]
            if let link = item.instagramPage {
                let name = "https://instagram.com/\(link)"
                open(name: name)
            }
        }
    }
}


// MARK: - AdvertiseElement
struct AdvertiseElement: Codable {
    let id, createDate, modifiedDate, title: String?
    let picURL, linkURL, instagramPage, phoneNumber: String?
    let type: Int?
    let advertiseDescription, startDate, endDate: String?
    let isRemender, isActive, isHomePageTop, isHomePageBottom: Bool?
    let isSearchPageBox, isSearchPageTop, isDetailEstatePageBox, isDetailEstatePageTop: Bool?
    let isContentPageBox, isContentPageTop, isContentDetailPageBox, isContentDetailPageTop: Bool?
    let isMobile: Bool?
    let sort: Int?
    let width:Int?
    let height:Int?

    enum CodingKeys: String, CodingKey {
        case id, createDate, modifiedDate, title
        case picURL = "picUrl"
        case linkURL = "linkUrl"
        case instagramPage, phoneNumber, type
        case advertiseDescription = "description"
        case startDate, endDate, isRemender, isActive, isHomePageTop, isHomePageBottom, isSearchPageBox, isSearchPageTop, isDetailEstatePageBox, isDetailEstatePageTop, isContentPageBox, isContentPageTop, isContentDetailPageBox, isContentDetailPageTop, isMobile, sort
        case height,width
    }
}

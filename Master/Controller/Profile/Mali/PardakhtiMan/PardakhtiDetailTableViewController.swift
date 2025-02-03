//
//  PardakhtiDetailTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI


class PardakhtiDetailTableViewController: UITableViewController {

    @IBOutlet weak var nahvePardakhtLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var codePeygiriPardakhtLabel: UILabel!
    @IBOutlet weak var tozihatLabel: UILabel!
    @IBOutlet weak var codeTakhfiflabel: UILabel!
    @IBOutlet weak var mizanTakhfifLabel: UILabel!
    @IBOutlet weak var noePardakhtLable: UILabel!
    @IBOutlet weak var vaziyatPardakhtLabel: UILabel!
    @IBOutlet weak var basteTakhfifiLabel: UILabel!
    @IBOutlet weak var shivePardakhtLable: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var codeMeliLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var id: String?
    var banks: [RCBankModelElement] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "جزئیات پرداخت"
        backBarButtonAttribute(color: .black, name: "")
        fetch(id: id)
    }

    func fetch(id: String?) {
        guard let id = id else { return }
        RestfulAPI<Empty,RCDetailPardakht>.init(path: "/User/order/detail/\(id)")
        .with(auth: .user)
        .with(method: .GET)
        .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                self.stopIndicatorAnimate()
                switch result {
                case .success(let res):
                    self.updateUI(item: res)
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    func getBankRequest() {
        RestfulAPI<Empty,[RCBankModelElement]>.init(path: "/Common/payment-gateway")
            .with(auth: .user)
            .with(method: .GET)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.banks = res
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
    }
    
    func updateUI(item: RCDetailPardakht?) {
        if let name = item?.user?.firstName, let lastname = item?.user?.lastName  {
            nameLabel.text = "\(name) \(lastname)"
        }
        codeMeliLabel.text = item?.user?.nationalCode
        mobileLabel.text = item?.user?.phoneNumber
        if let paymentMethod = item?.paymentMethod {
            var name = ""
            switch paymentMethod {
            case 1:
                name = "آنلاین"
            case 2: name = "بسته تخفیفاتی"
            case 3: name = "کیف پول"
            default:
                break
            }
            shivePardakhtLable.text = name
            nahvePardakhtLabel.text = name
        }
        
//        basteTakhfifiLabel.text = "" // esme key to model Response nabod ke bezaram bayad veporsm chie
        if let paymentMethod = item?.paymentMethod {
            vaziyatPardakhtLabel.text = PaymentMethodOrder.init(rawValue: paymentMethod)?.title()
        }
        mizanTakhfifLabel.text = "\(item?.priceDiscount ?? 0)"
        codeTakhfiflabel.text = item?.discountCode
        tozihatLabel.text = item?.rsBankDescription
        codePeygiriPardakhtLabel.text = item?.trackingCode
        bankLabel.text = item?.bank
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}



// MARK: - RSBank
struct RCDetailPardakht: Codable {
    let id, createDate, modifiedDate: String?
    let key: Int?
    let userID, estateID, packageID, packageUserID: String?
    let paymentMethod, paymentGateway, price, priceEnd: Int?
    let priceDiscount: Int?
    let discountCode: String?
    let status, type: Int?
    let isVerify, incInventory, isMobile: Bool?
    let rsBankDescription, payRefID, cardHolderPAN, trackingCode: String?
    let isTax: Bool?
    let tax: Int?
    let paymentDate, bank, digitalReceipt: String?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case user
        case id, createDate, modifiedDate, key
        case userID = "userId"
        case estateID = "estateId"
        case packageID = "packageId"
        case packageUserID = "packageUserId"
        case paymentMethod, paymentGateway, price, priceEnd, priceDiscount, discountCode, status, type, isVerify, incInventory, isMobile
        case rsBankDescription = "description"
        case payRefID = "payRefId"
        case cardHolderPAN, trackingCode, isTax, tax, paymentDate, bank, digitalReceipt
    }
}


enum PaymentMethodOrder: Int {
    case Pending = 0
    case Review = 1
    case Approve = 2
    case Failed = 3
    case PendingPay = 4
    case EditedPending = 5
    
    func title() -> String {
        switch self {
        case .Pending:
            return "در حال انتظار"
        case .Review:
            return "در حال بررسی"
        case .Approve:
            return "تایید شده"
        case .Failed:
            return "تایید نشده"
        case .PendingPay:
            return "در انتظار پرداخت"
        case .EditedPending:
            return "در انتظار ویرایش"
        }
    }
}

//
//  PaymentTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 3/28/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class PaymentTableViewController: UITableViewController {
    
    @IBOutlet weak var offPriceLabel: UILabel!
    @IBOutlet weak var offPriceStackView: UIStackView!
    
    @IBOutlet weak var discountPackageLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var discountCodeTextField: UITextField!
    @IBOutlet weak var walletPriceLabel: UILabel!
    @IBOutlet weak var paymentMethodSegmentControl: UISegmentedControl!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var offLineView: UIView!
    @IBOutlet weak var priceBamaliyatLabel: UILabel!
    
    var estateID: String?
    var packageId: String?
    var rcPayment: RCPaymentModel?
    var inverntory: Int?
    var rcDiscount: RCDiscount?
    var banks: [RCBankModelElement] = []
    var rcPackageItems: [RCPackageItem] = []
    var selectedBank: SelectionModel? {
        willSet {
            bankLabel.text = newValue?.title
        }
    }
    var discountPackage: SelectionModel? {
        willSet {
            discountPackageLabel.text = newValue?.title
        }
    }
    
    /*
     نوع پرداخت Type
     public enum OrderTypeEnum
     {
     InfoEstatatePhone = 1,
     LadderEstate = 2,
     VipEstate = 3,
     AddEstate = 4,
     //تمدید آگهی
     ExEstate = 5,
     DiscountPackage = 6,
     IncInventoryWallet = 7
     }
     */
    var type = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "پرداخت"
        paymentMethodSegmentControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.persianFont(size: 14)], for: .normal)
        self.paymentMethodSegmentControl.selectedSegmentIndex = 2
        updateUI()
        backBarButtonAttribute(color: .black, name: "")
    }
    
    func updateUI() {
        guard var rcPayment = rcPayment else { return }
        self.priceLabel.text = rcPayment.priceAdvertising?.seperateByCama ?? ""
        if let discountPrice = rcPayment.priceAdvertisingDiscount {
            self.offPriceLabel.text = discountPrice.seperateByCama
            rcPayment.priceAdvertising = discountPrice
            self.rcPayment?.priceAdvertising = discountPrice
            self.offLineView.alpha = 1
        } else {
            self.offLineView.alpha = 0
            self.offPriceStackView.alpha = 0.0
        }
        priceBaMaliatRequest(price: rcPayment.priceAdvertising)
        getBankRequest()
        fetchWalletRequest()
        fetchPackage()
    }
    
    func fetchPackage() {
        RestfulAPI<Empty,[RCPackageItem]>.init(path: "/DiscountPackage/use-pay/\(type)")
            .with(auth: .user)
            .with(method: .GET)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.rcPackageItems = res
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
    }
    
    func fetchWalletRequest() {
        RestfulAPI<Empty,RCInventory>.init(path: "/User/info")
            .with(auth: .user)
            .with(method: .GET)
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.inverntory = res.inventory
                        self.walletPriceLabel.text = "\((res.inventory ?? 0).seperateByCama)" + " " + "تومان"
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
    }
    
    func discountPriceRequest(price: Int, type: Int) {
        struct Send: Codable {
            let code: String
            let payType, price: Int
        }
        view.endEditing(true)
        RestfulAPI<Send,RCDiscount>.init(path: "/Pay/apply-discountcode-price")
            .with(auth: .user)
            .with(method: .POST)
            .with(body: Send(code: discountCodeTextField.text!, payType: type, price: price))
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.rcDiscount = res
                        if let msg = res.msg {
                            self.presentCDAlertWarningAlert(message: msg, completion: {})
                        }
                        if let priceEnd = res.priceEnd, priceEnd > 0 {
                            self.presentCDAlertWarningAlert(message: "تخفیف با موفقیت اعمال شد.", completion: {})
                            self.priceBaMaliatRequest(price: priceEnd)
                        }
                    case .failure(let err):
                        print(err)
                    }
                }
            }
    }
    
    func openGatewayURL(query: [String:String]) {
        if let url = URL(string: "https://melkita.com/pay/redirecttopay"), let urlWithQuery = url.withQuries(query), UIApplication.shared.canOpenURL(urlWithQuery) {
            print("bank URL: ",urlWithQuery)
            var str = "https://melkita.com/pay/redirecttopay?"
            for (key,value) in query {
                str += "\(key)=\(value)&"
            }
            if let newURL = URL(string: str) {
                print("NEWURL", newURL)
                UIApplication.shared.open(newURL, options: [:]) { status in
                    
                }
            }
            //            let webVC = PaymentWebViewController()
            //            print(url.relativeString, url.description)
            //            webVC.str = url.relativeString
            //            self.present(webVC, animated: true, completion: nil)
        }
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
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
    
    func priceBaMaliatRequest(price: Int?) {
        guard let price = price else { return }
        RestfulAPI<Empty,GenericOrginal<Int>>.init(path: "/Pay/apply-taxes-price")
            .with(auth: .user)
            .with(method: .GET)
            .with(queries: ["PriceEnd":"\(price)"])
            .sendURLSessionRequest { (result) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        let total = ((res.data ?? 0) + (price)).seperateByCama
                        self.priceBamaliyatLabel.text = "\(total)"
                        if self.offPriceLabel.alpha == 1 {
                            self.offPriceLabel.text = price.seperateByCama
                        } else {
                            self.priceLabel.text = price.seperateByCama
                        }
                        break
                    case .failure(let err):
                        print(err)
                    }
                }
            }
    }
    
    @IBAction func segmentControllValueChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    // code takhfif
    @IBAction func agreeButtonTapped(_ sender: Any) {
        guard let price = rcPayment?.priceAdvertising else { return }
        //        if price == rcPayment?.priceAdvertisingDiscount {
        //            // chon qeymat takhfif dare az qabl dg nabayad takhfif ro mohasebe kard
        //            presentCDAlertWarningAlert(message: "تخفیف قبلا لحاظ شده است", completion: {})
        //            return
        //        }
        switch paymentMethodSegmentControl.selectedSegmentIndex {
        case 0:
            discountPriceRequest(price: price, type: type)
        case 2:
            discountPriceRequest(price: price, type: type)
        default:break
        }
    }
    
    @IBAction func payButtonTapped(_ sender: Any) {
        guard let userID = DataManager.shared.userProfile?.data?.id else { return }
        var query = [
            "type":"\(type)",
            "userId":userID
        ]
        if let estateID = self.estateID {
            query.updateValue(estateID, forKey: "EstateId")
        }
        
        if let packageId = self.packageId {
            query.updateValue(packageId, forKey: "packageId")
        }
        
        switch paymentMethodSegmentControl.selectedSegmentIndex {
        case 0:
            guard let inverntory = self.inverntory, inverntory > 0 else {
                presentCDAlertWarningAlert(message: "موجودی حساب شما کافی نمیباشد", completion: {})
                return
            }
            query.updateValue("\(PaymentMethodEnum.Wallet.rawValue)", forKey: "paymentMethod")
            if let rcDiscount = rcDiscount {
                if rcDiscount.priceEnd != nil {
                    query.updateValue(discountCodeTextField.text!, forKey: "DiscountCode")
                }
            }
            
            self.openGatewayURL(query: query)
            break
        case 1:
            query.updateValue("\(PaymentMethodEnum.DiscountPackage.rawValue)", forKey: "paymentMethod")
            if let discountPackage = self.discountPackage {
                let index = self.rcPackageItems.firstIndex { item in
                    return item.id == discountPackage.id
                }
                if let index = index {
                    let item = rcPackageItems[index]
                    if let packageUserID = item.id {
                        query.updateValue(packageUserID, forKey: "PackageUserId")
                    }
                }
            } else {
                self.presentCDAlertWarningAlert(message: "بسته تخفیف خود را انتخاب کنید", completion: {})
                return
            }
            self.openGatewayURL(query: query)
            break
        case 2:
            if let bank = self.selectedBank {
                query.updateValue("\(PaymentMethodEnum.Online.rawValue)", forKey: "paymentMethod")
                query.updateValue(bank.id, forKey: "PaymentGateway")
                if let rcDiscount = rcDiscount {
                    if rcDiscount.priceEnd != nil {
                        query.updateValue(discountCodeTextField.text!, forKey: "DiscountCode")
                    }
                }
                self.openGatewayURL(query: query)
            } else {
                presentCDAlertWarningAlert(message: "لطفا درگاه پرداخت را انتخاب نمایید", completion: {})
                return
            }
        default:
            break
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch paymentMethodSegmentControl.selectedSegmentIndex {
        case 0:
            if indexPath.section == 1 { return 0 }
            if indexPath.section == 4 { return 0 }
        case 1:
            if indexPath.section == 2 { return 0 }
            if indexPath.section == 3 { return 0 }
            if indexPath.section == 4 { return 0 }
        case 2:
            if indexPath.section == 1 { return 0 }
        default:
            break
        }
        
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 4 {
            let vc = SelectionTableViewController.create()
            let selections = banks.map { SelectionModel(id: "\($0.key)", title: $0.title, section: .estayeBaseType) }
            vc.selectionModels = selections
            vc.delegate = self
            show(vc, sender: nil)
        }
        
        if indexPath.section == 1 {
            let vc = SelectionTableViewController.create()
            let selections = rcPackageItems.map { SelectionModel(id: $0.id ?? "", title: $0.title ?? "", section: .estayeBaseType) }
            vc.selectionModels = selections
            vc.delegate = self
            show(vc, sender: nil)
        }
    }
}

extension PaymentTableViewController: SelectionTableViewControllerDelegate {
    func didselectSection(item: SelectionModel) {
        if paymentMethodSegmentControl.selectedSegmentIndex == 2  {
            // online payment
            self.selectedBank = item
        } else if paymentMethodSegmentControl.selectedSegmentIndex == 1 {
            // package
            self.discountPackage = item
        }
    }
}

// section
// 0 segment
// 1 entekhab baste takhiff
// 2 mojodi kif pol
// 3 code takhfif
// 4 entekhab dargah

// segment
// 0 kif pol
// 1 baste takhfif
// 2 pardakht online


/*
 تو 7 بخش مختلف اپ پرداخت داریم
 1) نمایش اطلاعات تماس
 2) نردبان اگهی
 3) آگهی ویژه
 4) ثبت اگهی
 5) تمدید آگهی
 6) خرید بسته تخفیفی
 7) شارژ کیف پول
 */


// /api/v{version}/Pay/apply-discountcode-price // vase emal takhfif
// body : POST
/*
 {
 "code": "string",
 "payType": 0,
 "price": 0
 }
 */



/*
 وب سرویس لیست بسته های خریداری شده کاربر
 /api/v{version}/DiscountPackage/use-pay/{payType}
 */




/*
 // vase wallet
 https://api.melkita.com/api/v1/User/info
 */



/*
 dargah
 ​/api​/v{version}​/Common​/payment-gateway
 */



/*
 pardakht
 public class AddOrderVm
 {
 [Required]
 public short? Type { get; set; }
 public Guid? EstateId { get; set; }
 public short PaymentMethod { get; set; } = 1;
 public short PaymentGateway { get; set; }
 public string DiscountCode { get; set; }
 public Guid? PackageId { get; set; }
 public Guid? PackageUserId { get; set; }
 public string UserId { get; set; }
 }
 https://melkita.com/pay/redirecttopay
 
 2-ایدی اگهی
 3-شیوه پرداخت سه حالت وجود داره از enum مقادیرشا بخونید
 4-درگاه پرداخت مقدارش از وب سرویس لیست درگاه ها key را برا من ارسال کنید
 5) کد تخفیف اگه داشت ارسال کنید
 6) اگه میخواست بسته تخفیفی بخرع ایدی بسته که میخواد بخره
 7) اگه میخواست با بسته تخفیقی پرداخت کنه ایدی بسته تخفیفی که خریده با ایدی بالایی فرق داره
 8) ایدی کاربر لاگین کرده بعد از لاگین داخل مدلش موجوده
 */
/*
 type
 paymentMethod
 userId
 حتما در تمام پرداخت ها ارسال بشه بقیه موارد بستگی به نوع پرداخت و شیوه پرداخت داره
 */
/*
 نوع پرداخت Type
 public enum OrderTypeEnum
 {
 InfoEstatatePhone = 1, // phone
 LadderEstate = 2, // nardeban
 VipEstate = 3, // vije
 AddEstate = 4, // sakht agahi jadid
 //تمدید آگهی
 ExEstate = 5, // tamdid
 DiscountPackage = 6, kharid baste takhfifi
 IncInventoryWallet = 7
 }
 */
/*
 // shive pardakht
 public enum PaymentMethodEnum
 {
 Online = 1,
 DiscountPackage = 2,
 Wallet = 3
 }
 
 */

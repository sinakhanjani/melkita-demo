//
//  RegisterTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 3/3/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import SimpleCheckbox
import CoreLocation
import RestfulAPI
// MARK: - RegisterRes
struct RegisterRes: Codable {
    let isSuccess: Bool
    let msg: String?
}

// MARK: - RegisterSend
struct RegisterSend: Codable {
    let firstName, lastName, phoneNumber, nationalCode: String
    let role: Int
    let approveRules: Bool
    let identifierCode: String?
    let latitude, longitude: Double?
}

class RegisterTableViewController: UITableViewController, MapViewControllerDelegate {
    func coordinate(_ data: CLLocationCoordinate2D) {
        print(data)
        self.currentLocation = data
    }

    @IBOutlet weak var checkBox: Checkbox!
    @IBOutlet weak var IDTextField: InsetTextField!
    @IBOutlet weak var mobileTextField: InsetTextField!
    @IBOutlet weak var nameTextField: InsetTextField!
    @IBOutlet weak var lastnameTextField: InsetTextField!
    @IBOutlet weak var referralTextField: InsetTextField!
    
    var currentLocation: CLLocationCoordinate2D?

    var selectedIndexPath: IndexPath? {
        willSet {
            if newValue?.item == 0 {
                self.currentLocation = nil
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mobileTextField.keyboardType = .asciiCapableNumberPad
        IDTextField.keyboardType = .asciiCapableNumberPad
        referralTextField.keyboardType = .asciiCapableNumberPad
        backBarButtonAttribute(color: .black, name: "")
        //---- temp
        referralTextField.isEnabled = false
        referralTextField.backgroundColor = .lightGray
        // ---- temp
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.item {
            case 0:
                break
            case 1:
                if DataManager.shared.setting?.isDisableRegisterAdvisor == true { // moshaver
                    cell.backgroundColor = .gray
                    cell.isUserInteractionEnabled = false
                }
            case 2:
                if DataManager.shared.setting?.isDisableRegisterMarketer == true { // bazryab
                    cell.backgroundColor = .gray
                    cell.isUserInteractionEnabled = false
                }
            default:
                break
            }
            //--- temp
            if indexPath.item == 0 {
                cell.isUserInteractionEnabled = false
                cell.backgroundColor = .lightGray
            }
            // --- temp
        }
        if let selectedIndexPath = self.selectedIndexPath {
            if selectedIndexPath == indexPath {
                // temp
                if indexPath.item != 0 {
                    cell.accessoryType = .checkmark
                }
                //temp
                
//                cell.accessoryType = .checkmark // uncheck this after return
            } else {
                cell.accessoryType = .none
            }
        } else {
            cell.accessoryType = .none
        }
        if indexPath.section == 0 && indexPath.item == 0 {
            cell.accessoryType = .detailButton
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                let vc = HintViewController.create()
                vc.text = """
                    باتوجه به اینکه دروب سایت واپلیکشن های ملکیتا به سه روش میتوان ثبت نام نمود ووارد شد که ۳روش بدین شرح میباشد ۱-مشتریان عادی۲-مشاورین املاک۳-بازاریابان، که هرکدام بسته به نیازوخدماتشون امکانات کامل وجامعی داخل اکانتشون پیش بینی گردیده به همین خاطر به علت اینکه یک شخص نتواند به طور همزمان  از سه روش اعلام شده داخل ملکیتا ثبت نام واستفاده نمایداز انها هنگام ثبت نام ارسال کدملی را مشخص نموده ایم چون زمانیکه شخص به هر روشی که باکدملی خود درملکیتا ثبت نام نمود دیگر امکان ثبت نام به روش دیگر وجود نداشته باشد  ودریافت کدملی از اشخاص درزمان ثبت نام وورود درملکیتا فقط برای احراز هویت وسوء استفاده همزمان توسط یک شخص  از بقیه اکانت های ملکیتا میباشد .بادریافت کدملی ازاشخاص  امکان کلاهبرداری های اینترنتی  وخطاء توسط اشخاص به صفر میرسد
                    """
                present(vc, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if DataManager.shared.setting?.isDisableRegisterAdvisor == true && indexPath.item == 1 { // moshaver
                return 0
            }
            if DataManager.shared.setting?.isDisableRegisterMarketer == true && indexPath.item == 2 { // bazryab
                return 0
            }
        }
        
        if indexPath.section == 3 { // map
            if let selectedIndexPath = self.selectedIndexPath {
                if selectedIndexPath.item == 0 {
                    return 0 // user not map
                } else {
                    return 58
                }
            } else {
                return 0
            }
        }
        
        if indexPath.section == 2 && indexPath.section == 4 {
            return 58
        }
        return 48
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 1 {
            let cell = tableView.cellForRow(at: indexPath)
            
//            if selectedIndexPath == indexPath {
//                cell?.accessoryType = .none
//            } else {
//                cell?.accessoryType = .checkmark
//            }
            //----- temp
            if indexPath.item == 2 {
                cell?.accessoryType = .checkmark
            }
            // ---- temp
            
            self.selectedIndexPath = indexPath
            tableView.reloadData()
        }
        
        if indexPath.section == 2 {
            open(urlSting: "https://www.melkita.com/term")
        }
    }
    
    func open(urlSting: String) {
        guard let botURL = URL.init(string: urlSting) else {
            return
        }
        if UIApplication.shared.canOpenURL(botURL) {
            UIApplication.shared.openURL(botURL)
        }
    }

    @IBAction func  agreeButtonTapped() {
        guard checkBox.isChecked else {
            self.presentCDAlertWarningAlert(message: "لطفا قوانین را تایید کنید !", completion: {})
            return
        }
        guard let selectedIndexPath = selectedIndexPath else {
            self.presentCDAlertWarningAlert(message: "لطفا نوع کاربری خود را انتخاب کنید !", completion: {})
            return
        }
        guard selectedIndexPath.item == 2 else {
            self.presentCDAlertWarningAlert(message: "در حال حاضر فقط ثبت نام بازاریاب امکانپذیر میباشد", completion: {})
            return
        }
        if selectedIndexPath.item != 0 {
            if self.currentLocation == nil || currentLocation?.latitude == 0 {
                self.presentCDAlertWarningAlert(message: "لطفا موقعیت خود را از روی نقشه انتخاب کنید", completion: {})

                return
            }
        }
        print(currentLocation)
        var customerType: Int = 4
        
        if selectedIndexPath.item == 0 { // moshtari
            customerType = 0
        }
        if selectedIndexPath.item == 1 { // moshavere amlak
            customerType = 1
        }
        if selectedIndexPath.item == 2 { // bazaryab
            customerType = 2
        }
        guard customerType != 4 else {
            self.presentCDAlertWarningAlert(message: "لطفا نوع کاربری خود را مشخص کنید", completion: {})
            return
        }
        self.startIndicatorAnimate()
        let identfier:String? = referralTextField.text!.isEmpty ? nil:referralTextField.text!
        RestfulAPI<RegisterSend,RegisterRes>.init(path: "/Auth/register")
            .with(method: .POST)
            .with(body: RegisterSend(firstName: self.nameTextField.text!, lastName: lastnameTextField.text!, phoneNumber: mobileTextField.text!, nationalCode: IDTextField.text!, role: customerType, approveRules: true, identifierCode: identfier, latitude: currentLocation?.latitude, longitude: currentLocation?.longitude))
            .sendURLSessionRequest { (result) in
    
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        if res.isSuccess {
                            let vc = VerificationViewController.create()
                            vc.mobile = self.mobileTextField.text!
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            self.presentCDAlertWarningAlert(message: res.msg ?? "لطفا مجددا تلاش کنید", completion: {})
                        }
                    case .failure(_):
                        break
                    }
                }
            }
        // code..
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapVC" {
            let vc = segue.destination as! MapViewController
            vc.delegate = self
        }
    }
}

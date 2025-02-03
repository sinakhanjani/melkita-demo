//
//  MainProfileTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/10/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class MainProfileTableViewController: UITableViewController {
    enum SourceType {
        case video, photo, both
    }
    @IBOutlet weak var codeMoarefLabel: UILabel!
    @IBOutlet weak var bazaryabCodeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeKarbariLabel: UILabel!
    @IBOutlet weak var nameKarbariLabel: UILabel!
    @IBOutlet weak var codeMeliLabel: UILabel!
    @IBOutlet weak var imageView: CircleImageView!
    
    let imagePicker = UIImagePickerController()
    
    var item: RCUserInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .black, name: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUserInfoRequest()
    }
    
    func fetchUserInfoRequest() {
        RestfulAPI<Empty,RCUserInfo>.init(path: "/User/info")
        .with(auth: .user)
        .with(method: .GET)
        .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                self.stopIndicatorAnimate()
                switch result {
                case .success(let res):
                    self.item = res
                    self.updateUI()
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    func uploadImg(data: Data, params:Parameters) {
        guard let item = item, let name = item.firstName, let secondName = item.lastName else {
            
            return
        }
        var parameters: Parameters = ["FirstName":name,"LastName":secondName]
        params.forEach { param in
            parameters.updateValue(param.value, forKey: param.key)
        }
        RestfulAPI<File,GenericOrginal<EMPTYMODEL>>.init(path: "/User/edit-profile")
            .with(method: .PUT)
            .with(auth: .user)
            .with(parameters: parameters)
            .with(body: File(key: "Photo", data: data))
            .sendURLSessionRequest { result in
                if case .success(let res) = result {
                    DispatchQueue.main.async {
                        self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                    }
                }
            }
    }
    
    func updateUI() {
        if let name = item?.firstName, let lastname = item?.lastName  {
            nameLabel.text = "\(name) \(lastname)"
        }
        if let code = item?.key {
            codeKarbariLabel.text = "کد کاربری \(code)"
        }
        nameKarbariLabel.text = item?.phoneNumber
        if let code = item?.nationalCode {
            codeMeliLabel.text = "کد ملی \(code)"
        }
        if let url = item?.photoUrl {
            imageView.loadImageUsingCache(withUrl: url)
        }
        if let code = item?.marketerKey, !code.isEmpty {
            self.bazaryabCodeLabel.alpha = 1
            self.bazaryabCodeLabel.text = "کد بازاریاب \(code)"
        } else {
            self.bazaryabCodeLabel.alpha = 0
        }
        
        if let code = item?.identifierCode, !code.isEmpty {
            self.codeMoarefLabel.alpha = 1
            self.codeMoarefLabel.text = "کد معرف \(code)"
        } else {
            self.codeMoarefLabel.alpha = 0
        }
    }
    
    func choosenImageFrom(_ sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonTapped() {
        presentCDAlertWarningWithTwoAction(message: "انتخاب تصویر", buttonOneTitle: "گالری", buttonTwoTitle: "دوربین") {
            self.choosenImageFrom(.photoLibrary)
        } handlerButtonTwo: {
            self.choosenImageFrom(.camera)
        }
    }
    
    @IBAction func deleteImgButtonTapped() {
        //
    }
}


extension MainProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let dataImage = image.jpegData(compressionQuality: 0.1) {
                /////////
                self.uploadImg(data: dataImage, params: [:])
                self.imageView.image = image
                
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - RSBank
struct RCUserInfo: Codable {
    let isAdminRegister: Bool?
//    let postId: JSONNull?
    let provinceId: Int?
//    let registerMarketerPackageId, expireMarketerAccountDate, expireMarketerAccountAfterDate: JSONNull?
    let cityId: Int?
    let firstName: String?
    let key: Int?
    let marketerKey: String?
//    let identifierCode:
    let lastName: String?
    let companyName: String?
    let isAdvisor: Bool?
    let photoUrl: String?
    let phoneCenter: String?
    let isActive, isDelete, isMainMarketer, isDocument: Bool?
    let isApprove: Bool?
    let editedProfileStatus: Int?
//    let logGroup, messageFailedEditedProfile: JSONNull?
    let approveRules: Bool?
    let nationalCode: String?
    let inventory, credit: Int?
    let latitude, longitude: Double?
    let modifiedDate, createDate: String?
    let isPayRegisterPackageAndPendingMarketerCode: Bool?
//    let roles, estate, content, commentContent: JSONNull?
//    let estatePayUsers, orders, favo, document: JSONNull?
//    let documentUser, message, videos, discountPackageUser: JSONNull?
//    let profitMarketer, discountAdvisor, marketerBuy, marketerUser: JSONNull?
//    let deposit, bankCards, post, access: JSONNull?
//    let permission, provinceAccessUser, cityAccessUser, shiftWorkEmployee: JSONNull?
//    let marketerIntroDiscount, contentVideo, chatSender, chatRecive: JSONNull?
//    let chatMessages, regiterMarketerPackage: JSONNull?
    let id, userName, normalizedUserName: String
    let email: String?
    let emailConfirmed: Bool?
    let passwordHash, securityStamp, concurrencyStamp, phoneNumber: String?
    let phoneNumberConfirmed, twoFactorEnabled: Bool?
//    let lockoutEnd: JSONNull?
    let lockoutEnabled: Bool?
    let accessFailedCount: Int?
    let identifierCode: String?
    
    let registerMarketerPackageId: String?
    let expireMarketerAccountDate: String?
    let expireMarketerAccountAfterDate: String?
}

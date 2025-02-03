//
//  ErsalMadarekTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/19/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class ErsalMadarekTableViewController: UITableViewController {
    enum SourceType {
        case video, photo, both
    }
    
    @IBOutlet weak var sendButton: UIButton!
    
    var item: DocumentStatus?
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .black, name: "")
        title = "ارسال مدارک"
        fetch()
        
        let headerView = NotApproveView(height: 110)
        if (item?.documentUnApproved?.isEmpty == true) && (item?.documentPending?.isEmpty == false) {
            headerView.titleLabel.text = "شما قبلا مدارک خود را ارسال کرده‌اید، کارشناسان ما در حال بررسی هستند"
            self.sendButton.alpha = 0
            headerView.bgView.layer.borderColor = UIColor.orange.cgColor
            headerView.titleLabel.textColor = .orange
        } else {
            headerView.titleLabel.text = "لطفا مدارک خود را هر چه سریعتر آپلود نمایید."
        }
        self.tableView.tableHeaderView = headerView
    }
    
    func fetch () {
        ErsalMadarekTableViewController.fetchDocumentStatus { res in
            DispatchQueue.main.async {
                self.item = res
                let headerView = NotApproveView(height: 110)
                if (self.item?.documentUnApproved?.isEmpty == true) && (self.item?.documentPending?.isEmpty == false) {
                    headerView.titleLabel.text = "شما قبلا مدارک خود را ارسال کرده‌اید، کارشناسان ما در حال بررسی هستند"
                    self.sendButton.alpha = 0
                    headerView.bgView.layer.borderColor = UIColor.orange.cgColor
                    headerView.titleLabel.textColor = .orange
                } else {
                    headerView.titleLabel.text = "لطفا مدارک خود را هر چه سریعتر آپلود نمایید."
                }
                self.tableView.tableHeaderView = headerView
                self.tableView.reloadData()
                self.updateUI()
            }
        }
    }
    
    func updateUI() {
        //
    }
    
    @IBAction func sendButtonTapped() {
        let imgsData = self.item?.documentUnApproved?.map { $0.imgData }
        let ids = self.item?.documentUnApproved?.filter({ i in
            return i.imgData != nil
        }).map { $0.id! }
        var sendImgsData = [Data]()
        imgsData?.forEach({ data in
            if data != nil {
                sendImgsData.append(data!)
            }
        })
        
        guard !sendImgsData.isEmpty else {
            presentCDAlertWarningAlert(message: "لطفا مدارک خود را انتخاب کنید", completion: {})
            return
        }
        
        if let ids = ids {
            var params = [String:String]()
            var files = [File]()
            for (index,id) in ids.enumerated() {
                params.updateValue(id, forKey: "model[\(index)].documentId")
            }
            for (index,imgData) in sendImgsData.enumerated() {
                let file = File(key: "model[\(index)].doc", data: imgData)
                files.append(file)
            }
            sendDocRequest(files: files, params: params)
        }
    }
    
    func sendDocRequest(files: [File], params: Parameters) {
        self.startIndicatorAnimate()
        RestfulAPI<[File],GenericOrginal<EMPTYMODEL>>.init(path: "/User/document/send")
        .with(auth: .user)
            .with(method: .POST)
            .with(body: files)
            .with(parameters: params)
            .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                self.stopIndicatorAnimate()
                switch result {
                case .success(let res):
                    if res.isSuccess == true {
                        self.fetch()
                        self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                    }
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    static func fetchDocumentStatus(completion: @escaping (_ doc: DocumentStatus?) -> Void) {
        RestfulAPI<EMPTYMODEL,DocumentStatus>.init(path: "/User/document/status")
        .with(auth: .user)
            .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let res):
                    DataManager.shared.documentStatus = res
                    completion(res)
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item?.documentUnApproved?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.delegate = self
        if let item = item?.documentUnApproved?[indexPath.item] {
            cell.titleLabel1.text = item.title
            cell.backgroundColor = (item.imgData == nil) ? .white:.green
            if let img = item.picUrl {
                cell.circleImageView1.loadImageUsingCache(withUrl: img)
            }
            if let imgData = item.imgData {
                cell.button1.alpha = 1
                cell.circleImageView1.image = UIImage(data: imgData)
            } else {
                cell.button1.alpha = 0
                cell.circleImageView1.image = nil
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentCDAlertWarningWithTwoAction(message: "انتخاب تصویر", buttonOneTitle: "گالری", buttonTwoTitle: "دوربین") {
            self.choosenImageFrom(.photoLibrary)
        } handlerButtonTwo: {
            self.choosenImageFrom(.camera)
        }
    }
    
}

extension ErsalMadarekTableViewController: TableViewCellDelegate {
    func button1Tapped(sender: UIButton, cell: TableViewCell) {
        // delete button tapped
        if let indexPath = tableView.indexPath(for: cell) {
            self.item?.documentUnApproved?[indexPath.item].imgData = nil
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ErsalMadarekTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func choosenImageFrom(_ sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let dataImage = image.jpegData(compressionQuality: 0.1) {
                if let indexPath = tableView.indexPathForSelectedRow {
                    self.item?.documentUnApproved?[indexPath.item].imgData = dataImage
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - DocumentStatus
struct DocumentStatus: Codable {
    let isAccountApprove: Bool?
    let userId: String?
    let isPending, isApprove, isApproveAllDocSending: Bool?
    let unApproveCount: Int?
    let documentPending: [String]?
    var documentUnApproved: [DocumentUnApproved]?

}

// MARK: - DocumentUnApproved
struct DocumentUnApproved: Codable {
    let id, title, desc, picUrl: String?
    var imgData: Data? = nil
}

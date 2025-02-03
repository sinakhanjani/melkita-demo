//
//  CreateTicketTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/12/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import RestfulAPI

class CreateTicketTableViewController: UITableViewController {
    enum SourceType {
        case video, photo, both
    }
    
    @IBOutlet weak var subjectLabel: InsetTextField!
    @IBOutlet weak var bakhshLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var olaviyatLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let imagePicker = UIImagePickerController()

    var department: SelectionModel? {
        willSet {
            self.bakhshLabel.text = newValue?.title
        }
    }
    var level: SelectionModel? {
        willSet {
            self.olaviyatLabel.text = newValue?.title
        }
    }
    
    var imgsModel: [UIImage] = [UIImage(systemName: "tray.and.arrow.up.fill")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ارسال تیکت"
        backBarButtonAttribute(color: .black, name: "")
        textView.font = UIFont.persianFont(size: 17)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
    }
    
    func choosenImageFrom(_ sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            // bakhsh
            let vc = SelectionTableViewController.create()
            vc.selectionModels = DepartmentTicketEnum.allCases.map { SelectionModel(id: "\($0.rawValue)", title: $0.name(), section: .city) }
            vc.delegate = self
            navigationController?.show(vc, sender: nil)
        }
        if indexPath.section == 3 {
            // olaviyat
            let vc = SelectionTableViewController.create()
            vc.selectionModels = LevelTicketEnum.allCases.map { SelectionModel(id: "\($0.rawValue)", title: $0.name(), section: .city) }
            vc.delegate = self
            navigationController?.show(vc, sender: nil)
        }
    }
    
    @IBAction func doneButtonTapeed(_ sender: Any) {
        guard !subjectLabel.text!.isEmpty else {
            presentCDAlertWarningAlert(message: "لطفا موضوع خود را وارد کنید", completion: {})
            return
        }
        guard textView.text!.count > 8 else {
            presentCDAlertWarningAlert(message: "لطفا متن خود را کامل وارد کنید", completion: {})
            return
        }
        guard department != nil else {
            presentCDAlertWarningAlert(message: "لطفا بخش خود را انتخاب کنید", completion: {})
            return
        }
        guard level != nil else {
            presentCDAlertWarningAlert(message: "لطفا اولویت پیام خود را انتخاب کنید", completion: {})
            return
        }
        let params = ["Title":subjectLabel.text!,
                     "Department":department!.id,
                     "Level":level!.id,
                     "Text":textView.text!]
        print(params)
        var files: [File] = []
        for item in self.imgsModel {
            let file = File(key: "Attach", data: item.jpegData(compressionQuality: 0.1)!)
            files.append(file)
        }
        files.removeLast()
        self.startIndicatorAnimate()
        RestfulAPI<[File],GenericOrginal<EMPTYMODEL>>.init(path: "/Ticket")
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
                        self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    } else {
                        if let msg = res.msg {
                            self.presentCDAlertWarningAlert(message: msg, completion: {})
                        }
                    }
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
}

extension CreateTicketTableViewController: SelectionTableViewControllerDelegate {
    func didselectSection(item: SelectionModel) {
        if let indexPath = tableView.indexPathForSelectedRow {
            if indexPath.section == 2 {
                // bakhsh
                self.department = item
            }
            if indexPath.section == 3 {
                // olaviyat
                self.level = item
            }
        }
    }
}

extension CreateTicketTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let _ = image.jpegData(compressionQuality: 0.1) {
                //
                self.imgsModel.insert(image, at: 0)
                self.collectionView.reloadData()
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CreateTicketTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CollectionViewCellDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgsModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.delegate = self
        let item = imgsModel[indexPath.item]
        cell.imageView1.image = item
        if indexPath.item == self.imgsModel.count-1 {
            cell.button1.alpha = 0
        } else {
            cell.button1.alpha = 1
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize.init(width: collectionView.frame.height, height: collectionView.frame.height)
        return CGSize.init(width: 100, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == self.imgsModel.count-1 {
            presentCDAlertWarningWithTwoAction(message: "انتخاب تصویر", buttonOneTitle: "گالری", buttonTwoTitle: "دوربین") {
                self.choosenImageFrom(.photoLibrary)
            } handlerButtonTwo: {
                self.choosenImageFrom(.camera)
            }
        }
    }
    
    func button1Tapped(sender: UIButton, cell: CollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            if indexPath.item != self.imgsModel.count-1 {
                self.imgsModel.remove(at: indexPath.item)
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
    }
}

public enum DepartmentTicketEnum: Int, CaseIterable
 {
     //پشتیبانی فنی
     case TtechnicalDepartment = 0
     // امور مالی
     case FinancialDepartment = 1
     // انتقاد وپیشنهاد
     case SuggestionDepartment = 2
     //شکایت
     case ComplaintDepartment = 3
    
    func name() -> String {
        switch self {
        case .TtechnicalDepartment:
            return "دپارتمان کارشناسان و کلیه آگهی‌های املاک"
        case .FinancialDepartment:
            return "دپارتمان بازاریابان و مشاورین املاک ملکیتا"
        case .SuggestionDepartment:
            return "دپارتمان پذیرش تبلیغات ملکیتا و امور مالی"
        case .ComplaintDepartment:
            return "دپارتمان پیشنهادات و شکایات"
        }
    }
 }
 


public enum LevelTicketEnum: Int,CaseIterable
 {
     case Low = 0
     case Normal = 1
     case Important = 2
     case HighImportant = 3
    
    func name() -> String {
        switch self {
        case .Low:
            return "کم"
        case .Normal:
            return "متوسط"
        case .Important:
            return "مهم"
        case .HighImportant:
            return "بسیار مهم"
        }
    }
 }
 

public enum StatusTicketEnum: Int, CaseIterable
 {
     //در انتظار پاسخ
     case Pending = 0
     // پاسخ داده شد
     case Reply = 1
     // در حال بررسی
     case Review = 2
     // بدون پاسخ
     case NoAnswer = 3
     //بسته شده
     case Closed = 4
    
    func color() -> UIColor {
        if self == .Reply {
            return #colorLiteral(red: 0.1215686275, green: 0.3978117858, blue: 0.1953154064, alpha: 1)
        } else {
            return #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
    }
    func name() -> String {
        switch self {
        case .Pending:
            return "در انتظار پاسخ"
        case .Reply:
            return  "پاسخ داده شده"
        case .Review:
            return "در حال بررسی"
        case .Closed:
            return "بسته شده"
        case .NoAnswer:
            return "بدون پاسخ"
        }
    }
 }


//
//  AddAgahiStep5TableViewController.swift
//  Master
//
//  Created by Sina khanjani on 4/26/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import CoreMedia
import AVFoundation
import RestfulAPI

// MARK: - ImageRe
struct ImageRes: Codable {
    let id, picURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case picURL = "picUrl"
    }
}


struct VideoRes: Codable {
    let id, videoUrl,userId: String?

    enum CodingKeys: String, CodingKey {
        case id
        case videoUrl, userId
    }
}

class AddAgahiStep5TableViewController: UITableViewController {
    enum SourceType {
        case video, photo, both
    }
    
    @IBOutlet weak var collectionView: UICollectionView!

    let imagePicker = UIImagePickerController()
    var videoData: Data?
    var videoURL : URL?
    var imgsModel: [ImageRes] = []
    
    var videoRes: VideoRes?
    var addAgahi = AddAgahiModelBody()
    var addInfo: AddInfo?
    
    var isUpdate = false
    var updateEstateID: String?
    var agahiModel: AgahiModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        backBarButtonAttribute(color: .black, name: "")
        title = "ثبت آگهی"
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        
        if isUpdate {
            if let updateEstateID = self.updateEstateID {
                fetchImg(id: updateEstateID)
                //
                if agahiModel?.videoURL != nil {
                    self.videoRes = VideoRes(id: addAgahi.videoID, videoUrl: agahiModel?.videoURL, userId: DataManager.shared.userProfile?.data?.id)
                    if let videoRes = videoRes {
                        addAgahi.videoID = videoRes.id
                    }
                }
            }
        }
    }
    
    func fetchImg(id: String) {
        self.startIndicatorAnimate()
        RestfulAPI<EMPTYMODEL,[ImageRes]>.init(path: "/Estate/pictures/\(id)")
            .with(method: .GET)
            .with(auth: .user)
            .sendURLSessionRequest { result in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.imgsModel = res
                        let imgsID = self.imgsModel.map { $0.id }
                        self.addAgahi.pics = imgsID.isEmpty ? nil: imgsID
                        self.collectionView.reloadData()
                    case .failure(_):
                        break
                    }
                }
            }
    }
    
    
    func updatingImageRequest(data: Data, id:String) {
        self.startIndicatorAnimate()
        RestfulAPI<File,ImageRes>.init(path: "/Estate/upload-img")
            .with(method: .POST)
            .with(auth: .user)
            .with(parameters: ["EstateId":id])
            .with(body: File(key: "File", data: data))
            .sendURLSessionRequest { result in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.imgsModel.append(res)
                        self.collectionView.reloadData()
                    case .failure(_):
                        break
                    }
                }
            }
    }

    
    func sendImageRequest(data: Data) {
        self.startIndicatorAnimate()
        RestfulAPI<File,ImageRes>.init(path: "/Estate/upload-img")
            .with(method: .POST)
            .with(auth: .user)
            .with(body: File(key: "File", data: data))
            .sendURLSessionRequest { result in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.imgsModel.append(res)
                        self.collectionView.reloadData()
                    case .failure(_):
                        break
                    }
                }
            }
    }

    func deleteImg(id: String) {
        self.startIndicatorAnimate()
        RestfulAPI<Empty,GenericOrginal<EMPTYMODEL>>.init(path: "/Estate/pictures/\(id)")
            .with(method: .DELETE)
            .with(auth: .user)
            .sendURLSessionRequest { result in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        print("IAMGE IS DELETED")
                        self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                        self.collectionView.reloadData()
                    case .failure(_):
                        break
                    }
                }
            }
    }
    
    func uploadVideoRequest(data: Data) {
        self.startIndicatorAnimate()
        RestfulAPI<File,GenericOrginal<VideoRes>>.init(path: "/Estate/video/upload")
            .with(method: .POST)
            .with(auth: .user)
            .with(body: File(key: "File", data: data, mime: .mp4))
            .sendURLSessionRequest { result in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        print("VIDEO IS UPLOADED")
                        self.videoRes = res.data
                        self.presentCDAlertWarningAlert(message: res.msg ?? "ویدیو آپلود شد", completion: {})
                        self.tableView.reloadData()
                        break
                    case .failure(_):
                        break
                    }
                }
            }
    }
    
    func deleteVideo(id: String) {
        self.startIndicatorAnimate()
        RestfulAPI<Empty,GenericOrginal<EMPTYMODEL>>.init(path: "/Estate/video/\(id)")
            .with(method: .DELETE)
            .with(auth: .user)
            .sendURLSessionRequest { result in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                    switch result {
                    case .success(let res):
                        self.presentCDAlertWarningAlert(message: res.msg ?? "", completion: {})
                        print("VIDEO IS DELETED")
                        self.videoRes = nil
                        self.videoData = nil
                        self.tableView.reloadData()
                    case .failure(_):
                        break
                    }
                }
            }
    }
    
    func choosenImageFrom(_ sourceType: UIImagePickerController.SourceType) {
        imagePicker.mediaTypes = ["public.image"]
        
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func selectedImageButtonTapped(_ sender: Any) {
        presentCDAlertWarningWithTwoAction(message: "انتخاب تصویر", buttonOneTitle: "گالری", buttonTwoTitle: "دوربین") {
            self.choosenImageFrom(.photoLibrary)
        } handlerButtonTwo: {
            self.choosenImageFrom(.camera)
        }
    }
    
    @IBAction func agreeButtonTapped(_ sender: Any) {
        if let videoRes = videoRes {
            addAgahi.videoID = videoRes.id
        }
        let imgsID = imgsModel.map { $0.id }
        addAgahi.pics = imgsID.isEmpty ? nil: imgsID
        
        let vc = AddAgahiStep6TableViewController.create()
        vc.addAgahi = addAgahi
        vc.addInfo = addInfo
        
        vc.isUpdate = isUpdate
        vc.agahiModel = agahiModel
        vc.updateEstateID = updateEstateID
        
        show(vc, sender: nil)
    }
    
    @IBAction func videoUploadButtonTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.movie"]
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func videoDeleteButtonTapped(_ sender: Any) {
        if let id = videoRes?.id {
            self.deleteVideo(id: id)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 312
        }
        if indexPath.section == 1 {
            if indexPath.item == 0 {
                return 158
            }
            if videoData != nil { // if video uploaded
                return 202
            } else {
                return 0
            }
        }
        
        return 58 // only button
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.item == 1 {
            // video clicked
            if let urlVideo = videoRes?.videoUrl {
                let urlStr = "https://www.melkita.com"+urlVideo
                if let url = URL(string: urlStr) {
                    self.playVideo(url: url)
                }
            }
        }
    }
}

extension AddAgahiStep5TableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CollectionViewCellDelegate {
    
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
        cell.imageView1.loadImageUsingCache(withUrl: item.picURL)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize.init(width: collectionView.frame.height, height: collectionView.frame.height)
        return CGSize.init(width: 100, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func button1Tapped(sender: UIButton, cell: CollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            // delete image
            let item = self.imgsModel[indexPath.item]
            self.imgsModel.remove(at: indexPath.item)
            self.deleteImg(id: item.id )

        }
    }
}

extension AddAgahiStep5TableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaTypeImport = info[UIImagePickerController.InfoKey.mediaType] as? String {
            
            if mediaTypeImport  == "public.image" {
                if let image = info[.originalImage] as? UIImage {
                    if let dataImage = image.jpegData(compressionQuality: 0.1) {
                        /////////
                        if isUpdate {
                            self.updatingImageRequest(data: dataImage, id: self.updateEstateID ?? "")
                        } else {
                            self.sendImageRequest(data: dataImage)
                        }
                    }
                }
            }
            
            if mediaTypeImport == "public.movie" {
                guard let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
                let duration = CMTimeGetSeconds(AVAsset(url: videoURL).duration)
                guard duration <= 60 else {
                    let message = "زمان ویدیو بیشتر از یک دقیقه می باشد"
                    self.presentCDAlertWarningAlert(message: message) {}
                    return
                }
                
                let video = try? Data(contentsOf: videoURL, options: .mappedIfSafe)
                
                guard let safeVideo = video else { self.dismiss(animated: true, completion: nil) ; return }
                print("Capicity: \(safeVideo.count)")
                guard !(safeVideo.count >= 199000000) else {
                    let message = "حجم فایل بیشتر از 200 مگابایت می باشد"
                    self.presentCDAlertWarningAlert(message: message) { }
                    return
                }
             // here
                self.videoURL = videoURL
                self.videoData = safeVideo
                self.uploadVideoRequest(data: safeVideo)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

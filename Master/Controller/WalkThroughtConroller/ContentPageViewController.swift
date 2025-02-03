//
//  CarioContentPageViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 8/1/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class ContentPageViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backButtonButton: UIButton!
    @IBOutlet weak var welcomeImageView: UIImageView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var imageViewTwo: UIImageView!
    
    var index = 0
    var imageFile = ""
    var detail = ""
    var subject = ""
    var secendImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Action
    @IBAction func forwardButtonTapped(_ sender: UIButton) {
        switch index {
        case 0...1:
            let pageViewController = parent as! WalkThroughViewController
            pageViewController.forward(index: index)
        case 2:

            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {

        dismiss(animated: true, completion: nil)
    }
    
    // Method
    func updateUI() {
        pageControl.currentPage = index
        welcomeImageView.image = UIImage.init(named: imageFile)
        subjectLabel.text = subject
        detailLabel.text = detail
        if secendImage != "" {
            imageViewTwo.image = UIImage.init(named: secendImage)
        } else {
            imageViewTwo.image = UIImage()
            
        }
        switch index {
        case 0...1:
            break
        case 2:
            break
        default:
            break
        }
    }
}

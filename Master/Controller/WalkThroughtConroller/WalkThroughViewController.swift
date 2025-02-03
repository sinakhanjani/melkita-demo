//
//  WalkThroughViewController.swift
//  Master
//
//  Created by Sinakhanjani on 4/17/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

class WalkThroughViewController: UIPageViewController,UIPageViewControllerDataSource {

    var pageImages: [String] = [""]
    var pageSubjects: [String] = [""]
    var pageDetails: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Method
    func updateUI() {
        dataSource = self
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentPageViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentPageViewController).index
        index += 1
        return contentViewController(at: index)
    }
    
    func contentViewController(at index: Int) -> ContentPageViewController? {
        if index < 0 || index >= 3 {
            return nil
        }
        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "ContentPageViewController") as? ContentPageViewController {
            pageContentViewController.index = index
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.subject = pageSubjects[index]
            pageContentViewController.detail = pageDetails[index]
            return pageContentViewController
        }
        return nil
    }
    
    func forward(index: Int) {
        if let nextViewController = contentViewController(at: index + 1) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    static func createMe() -> WalkThroughViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: String(describing: self)) as! WalkThroughViewController
    //    vc.modalTransitionStyle =
    //    vc.modalPresentationStyle =
        return vc
    }

    

}

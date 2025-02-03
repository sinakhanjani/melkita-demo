//
//  CornerView.swift
//  Master
//
//  Created by Sina khanjani on 6/16/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

@IBDesignable
class CornerView: UIView {

    
    var corners: UIRectCorner = []
    let customMask = CAShapeLayer()
    
    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet {
            setCorners()
        }
    }
    
    @IBInspectable var cornerTopLeft: Bool = false {
        didSet {
            if cornerTopLeft {
                self.corners.insert(.topLeft)
            }
            setCorners()
        }
    }
    
    @IBInspectable var cornerTopRight: Bool = false {
        didSet {
            if cornerTopRight {
                self.corners.insert(.topRight)
            }
            setCorners()
        }
    }
    
    @IBInspectable var cornerBottomRight: Bool = false {
        didSet {
            if cornerBottomRight {
                self.corners.insert(.bottomRight)
            }
            setCorners()
        }
    }
    
    @IBInspectable var cornerBottomLeft: Bool = false {
        didSet {
            if cornerBottomLeft {
                self.corners.insert(.bottomLeft)
            }
            setCorners()
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
        setCorners()

    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setCorners()
    }
    
    func setupView() {
        setCorners()
    }
    
    func setCorners() {
        self.layoutIfNeeded()
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: self.corners, cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius))
        self.customMask.path = path.cgPath
        self.layer.mask = self.customMask
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    
}

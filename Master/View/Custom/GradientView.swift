//
//  GradientView.swift
//  Pay Line
//
//  Created by Sinakhanjani on 9/25/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit


@IBDesignable
class GradientView: RoundedView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        super.setupView()
    }
    
    @IBInspectable var topColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var centerColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var upToDown: Bool = true {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        if centerColor != .clear {
            gradientLayer.colors?.insert(centerColor, at: 1)
        }
        if self.upToDown {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        }
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0) // at 0 means first layer
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        super.setupView()
    }
    
    
}

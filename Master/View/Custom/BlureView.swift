//
//  BlureView.swift
//  Master
//
//  Created by Sina khanjani on 6/16/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit
import VisualEffectView

@IBDesignable
class BlurView: RoundedView {
    
    @IBInspectable var blurColor: UIColor = .white {
        didSet {
            configureBlur()
        }
    }
    
    @IBInspectable var blurRadius: CGFloat = 0.0 {
        didSet {
            configureBlur()
        }
    }
    
    @IBInspectable var blurAlpha: CGFloat = 0.0 {
        didSet {
            configureBlur()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        super.setupView()
        configureBlur()
    }
    
    func configureBlur() {
        let view = VisualEffectView()
        view.tint(blurColor, blurRadius: blurRadius)
        view.colorTint = blurColor
        view.colorTintAlpha = blurAlpha
        view.blurRadius = blurRadius
        addSubview(view)
        view.constrainToEdges()
        self.clipsToBounds = true
        view.clipsToBounds = true
        self.sendSubviewToBack(view)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        super.setupView()
        configureBlur()
    }
    
}


extension UIView {
    @discardableResult
    func constrain(constraints: (UIView) -> [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        let constraints = constraints(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    @discardableResult
    func constrainToEdges(_ inset: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        return constrain {[
            $0.topAnchor.constraint(equalTo: $0.superview!.topAnchor, constant: inset.top),
            $0.leadingAnchor.constraint(equalTo: $0.superview!.leadingAnchor, constant: inset.left),
            $0.bottomAnchor.constraint(equalTo: $0.superview!.bottomAnchor, constant: inset.bottom),
            $0.trailingAnchor.constraint(equalTo: $0.superview!.trailingAnchor, constant: inset.right)
            ]}
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
    }
    class var red: UIColor { return UIColor(red: 255, green: 59, blue: 48) }
    class var orange: UIColor { return UIColor(red: 255, green: 149, blue: 0) }
    class var yellow: UIColor { return UIColor(red: 255, green: 204, blue: 0) }
    class var green: UIColor { return UIColor(red: 76, green: 217, blue: 100) }
    class var tealBlue: UIColor { return UIColor(red: 90, green: 200, blue: 250) }
    class var blue: UIColor { return UIColor(red: 0, green: 122, blue: 255) }
    class var purple: UIColor { return UIColor(red: 88, green: 86, blue: 214) }
    class var pink: UIColor { return UIColor(red: 255, green: 45, blue: 85) }
    class var allCases: [UIColor] {
        return [red, orange, yellow, green, tealBlue, blue, purple, pink]
    }
}

extension VisualEffectView {
    func tint(_ color: UIColor, blurRadius: CGFloat) {
        self.colorTint = color
        self.colorTintAlpha = 0.5
        self.blurRadius = blurRadius
    }
}


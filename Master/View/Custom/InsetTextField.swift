//
//  InsetTextField.swift
//  Pay Line
//
//  Created by Sinakhanjani on 9/23/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

//@IBDesignable
class InsetTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    
    override func reloadInputViews() {
        super.reloadInputViews()
    }    
}

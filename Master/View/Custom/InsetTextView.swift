//
//  InsetTextView.swift
//  Master
//
//  Created by Sina khanjani on 5/27/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

class InsetTextView: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont.persianFont(size: 16)
    }

}

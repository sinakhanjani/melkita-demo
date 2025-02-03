//
//  TextFieldTableViewCell.swift
//  Master
//
//  Created by Sina khanjani on 3/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit

protocol TextFieldTableViewCellDelegate: AnyObject {
    func textFieldInputValueChanged(_ sender: UITextField)
}

class TextFieldTableViewCell: UITableViewCell {
    @IBOutlet weak var nameTextField: UITextField!

    weak var delegate: TextFieldTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameTextField.keyboardType = .asciiCapableNumberPad
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func textFiledValueChannged(_ sender: UITextField) {
        delegate?.textFieldInputValueChanged(sender)
    }

}

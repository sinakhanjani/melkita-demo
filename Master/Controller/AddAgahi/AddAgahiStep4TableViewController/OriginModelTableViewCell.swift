//
//  OriginModelTableViewCell.swift
//  Master
//
//  Created by Sina khanjani on 4/26/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import SimpleCheckbox


protocol OriginModelTableViewCellDelegate: AnyObject {
    func TitleTextFieldValueChanged(_ sender: UITextField, cell: OriginModelTableViewCell)
}

class OriginModelTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBox: Checkbox!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    weak var delegate: OriginModelTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func textFiledValueChannged(_ sender: UITextField) {
        delegate?.TitleTextFieldValueChanged(sender, cell: self)
    }
}

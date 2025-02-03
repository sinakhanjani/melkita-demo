//
//  CheckBoxTableViewCell.swift
//  Master
//
//  Created by Sina khanjani on 3/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import SimpleCheckbox

protocol CheckBoxTableViewCellDelegate: AnyObject {
    func newAgeCheckBoxDidChange(cell: CheckBoxTableViewCell)
}


class CheckBoxTableViewCell: UITableViewCell {
    @IBOutlet weak var checkBox: Checkbox!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

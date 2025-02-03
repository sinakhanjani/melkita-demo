//
//  AgahiManTableViewCell.swift
//  Master
//
//  Created by Sina khanjani on 5/10/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import SimpleCheckbox

protocol AgahiManTableViewCellDelegate {
    func deleteButtonTapped(cell: AgahiManTableViewCell)
    func editButtonTapped(cell: AgahiManTableViewCell)
    func payButtonTapped(cell: AgahiManTableViewCell)
    func nardebanButtonTapped(cell: AgahiManTableViewCell)
    func vjiheButtonTapped(cell: AgahiManTableViewCell)
}

class AgahiManTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vaziyatAgahiLabel:UILabel!
    @IBOutlet weak var nameMelkLabel:UILabel!
    @IBOutlet weak var agahiImageView:UIImageView!
    
    @IBOutlet weak var checkMark: Checkbox!
    @IBOutlet weak var kharidYaForoshTagButton:UIButton!
    @IBOutlet weak var categoryTagButton:UIButton!
    @IBOutlet weak var subCategoryTagButton:UIButton!
    @IBOutlet weak var dateTagButton:UIButton!
    @IBOutlet weak var forokhteShodeTagButton:UIButton!
    @IBOutlet weak var agahiView: UIView!
    
    @IBOutlet weak var addressLabel:UILabel!

    @IBOutlet weak var editButton:UIButton!
    @IBOutlet weak var deleteButton:UIButton!
    @IBOutlet weak var payButton:UIButton!

    @IBOutlet weak var nardebanButton:UIButton!
    @IBOutlet weak var vijeButton:UIButton!
    
    var delegate: AgahiManTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func hideAllButton() {
        if !DataManager.shared.isApproveDocument {
            self.editButton.alpha = 0
            self.payButton.alpha = 0
            self.nardebanButton.alpha = 0
            self.vijeButton.alpha = 0
            checkMark.alpha = 0
            return
        }
    }
    
    @IBAction func deleteButtonTapped() {
        delegate?.deleteButtonTapped(cell: self)
    }
    
    @IBAction func editButtonTapped() {
        delegate?.editButtonTapped(cell: self)
    }
    
    @IBAction func payButtonTapped() {
        delegate?.payButtonTapped(cell: self)
    }
    
    @IBAction func nardebanButtonTapped() {
        delegate?.nardebanButtonTapped(cell: self)
    }
    
    @IBAction func vjiheButtonTapped() {
        delegate?.vjiheButtonTapped(cell: self)
    }
}

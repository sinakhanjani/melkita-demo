//
//  BasteTakhfifiTableViewCell.swift
//  Master
//
//  Created by Sina khanjani on 5/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit

protocol BasteTakhfifiTableViewCellDelegate {
    func tarakoneshButtonTapped(cell: BasteTakhfifiTableViewCell)
    func payButtonTapped(cell: BasteTakhfifiTableViewCell)
    func switchValueChanged(_ sender: UISwitch, cell: BasteTakhfifiTableViewCell)
}

class BasteTakhfifiTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    
    @IBOutlet weak var iconImageView1: UIImageView!
    @IBOutlet weak var iconImageView2: UIImageView!
    @IBOutlet weak var iconImageView3: UIImageView!
    @IBOutlet weak var iconImageView4: UIImageView!
    @IBOutlet weak var iconImageView5: UIImageView!

    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var label8: UILabel!
    @IBOutlet weak var label9: UILabel!
    
    @IBOutlet weak var offLineView: UIView!
    
    // other cell 2
    @IBOutlet weak var switch1: UISwitch!
    
    var delegate:BasteTakhfifiTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func tarakoneshButtonTapped() {
        delegate?.tarakoneshButtonTapped(cell: self)
    }
    
    @IBAction func payButtonTapped() {
        delegate?.payButtonTapped(cell: self)
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        delegate?.switchValueChanged(sender, cell: self)
    }
}

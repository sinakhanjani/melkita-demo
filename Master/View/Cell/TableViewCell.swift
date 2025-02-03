//
//  TableViewCell.swift
//  Master
//
//  Created by Sina khanjani on 6/16/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

@objc protocol TableViewCellDelegate {
    @objc optional func button1Tapped(sender: UIButton,cell:TableViewCell)
    @objc optional func button2Tapped(sender: UIButton,cell:TableViewCell)
    @objc optional func button3Tapped(sender: UIButton,cell:TableViewCell)
    @objc optional func button4Tapped(sender: UIButton,cell:TableViewCell)
    @objc optional func switch1ValueChanged(sender: UISwitch,cell:TableViewCell)
    @objc optional func switch2ValueChanged(sender: UISwitch,cell:TableViewCell)
}

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var roundedView1:RoundedView!
    @IBOutlet weak var roundedView2:RoundedView!
    @IBOutlet weak var roundedView3:RoundedView!
    @IBOutlet weak var bgView1:UIView!
    @IBOutlet weak var bgView2:UIView!
    @IBOutlet weak var bgView3:UIView!
    @IBOutlet weak var titleLabel1:UILabel!
    @IBOutlet weak var titleLabel2:UILabel!
    @IBOutlet weak var titleLabel3:UILabel!
    @IBOutlet weak var titleLabel4:UILabel!
    @IBOutlet weak var titleLabel5:UILabel!
    @IBOutlet weak var titleLabel6:UILabel!
    @IBOutlet weak var titleLabel7:UILabel!
    @IBOutlet weak var titleLabel8:UILabel!

    @IBOutlet weak var imageView1:UIImageView!
    @IBOutlet weak var imageView2:UIImageView!
    @IBOutlet weak var imageView3:UIImageView!
    @IBOutlet weak var imageView4:UIImageView!
    @IBOutlet weak var circleImageView1:CircleImageView!
    @IBOutlet weak var circleImageView2:CircleImageView!
    @IBOutlet weak var button1:UIButton!
    @IBOutlet weak var button2:UIButton!
    @IBOutlet weak var button3:UIButton!
    @IBOutlet weak var button4:UIButton!
    @IBOutlet weak var switch1:UISwitch!
    @IBOutlet weak var switch2:UISwitch!
    @IBOutlet weak var insetTextView1:InsetTextView!
    @IBOutlet weak var insetTextView2:InsetTextView!
    
    var delegate: TableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
            //
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func button1Tapped(_ sender: UIButton) {
        delegate?.button1Tapped?(sender: sender, cell: self)
    }
    
    @IBAction func button2Tapped(_ sender: UIButton) {
        delegate?.button2Tapped?(sender: sender, cell: self)
    }
    
    @IBAction func button3Tapped(_ sender: UIButton) {
        delegate?.button3Tapped?(sender: sender, cell: self)
    }
    
    @IBAction func button4Tapped(_ sender: UIButton) {
        delegate?.button4Tapped?(sender: sender, cell: self)
    }

    @IBAction func switch1ValueChanged(_ sender: UISwitch) {
        delegate?.switch1ValueChanged?(sender: sender, cell: self)
    }
    
    @IBAction func switch2ValueChanged(_ sender: UISwitch) {
        delegate?.switch1ValueChanged?(sender: sender, cell: self)
    }
    
}

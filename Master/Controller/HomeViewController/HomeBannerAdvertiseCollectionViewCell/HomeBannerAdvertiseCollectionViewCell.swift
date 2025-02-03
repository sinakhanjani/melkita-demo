//
//  HomeBannerAdvertiseCollectionViewCell.swift
//  Master
//
//  Created by Sina khanjani on 3/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit

class HomeBannerAdvertiseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var tagButton: RoundedButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    var delegate: LoveDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func loveTapped(_ sender: Any) {
        delegate?.loveButtonTapped(cell: self)
    }
    
}

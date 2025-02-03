//
//  HomeAdvertiseCollectionViewCell.swift
//  Master
//
//  Created by Sina khanjani on 3/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit

protocol LoveDelegate {
    func loveButtonTapped(cell: UICollectionViewCell)
}

class HomeAdvertiseCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var sellPriceLabel: UILabel!
    @IBOutlet weak var buyPriceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var tagButton: RoundedButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    var delegate: LoveDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    @IBAction func tagButtonTapped(_ sender: Any) {
        delegate?.loveButtonTapped(cell: self)
    }
}

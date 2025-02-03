//
//  SectionHeaderView.swift
//  Master
//
//  Created by Sina khanjani on 3/11/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.persianFont(size: 17)
        label.textColor = .label
        label.textAlignment = .right
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        label.text = title
    }
}

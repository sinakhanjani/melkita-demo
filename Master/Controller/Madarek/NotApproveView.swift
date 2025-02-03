//
//  NotApproveView.swift
//  Master
//
//  Created by Sina khanjani on 5/19/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import Foundation


class NotApproveView: UIView {
        
    let bgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = UIFont.persianFont(size: 16)
        label.numberOfLines = 0
        label.text = ""
        label.textAlignment = .right
        
        return label
    }()

    init(height: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: height))

        backgroundColor = .clear
        
        addSubview(bgView)
        bgView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            // bgView constraint:
            bgView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            bgView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            bgView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            // titleLabel constraint:
            titleLabel.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

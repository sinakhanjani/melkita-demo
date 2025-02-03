//
//  NavigationView.swift
//  Master
//
//  Created by Sina khanjani on 6/16/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit


@IBDesignable
class NavigationView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.init(name: Constant.Fonts.casablancaRegular, size: 25)
        label.textColor = Constant.Color.green
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let leftContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let rightContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let leftButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(nil, for: .normal)
        button.addTarget(self, action: #selector(leftButtonSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let rightButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(nil, for: .normal)
        button.addTarget(self, action: #selector(rightButtonSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var completionHandler: (() -> Void)?
    
    
    @IBInspectable var navigationTitle: String = "" {
        didSet {
            titleLabel.text = navigationTitle
            layoutIfNeeded()
        }
    }
    
    @IBInspectable var buttonImage: UIImage = UIImage() {
        didSet {
            leftButton.setImage(buttonImage, for: .normal)
            layoutIfNeeded()
        }
    }
    
    @IBInspectable var rightButtonImage: UIImage = UIImage() {
        didSet {
            rightButton.setImage(rightButtonImage, for: .normal)
            layoutIfNeeded()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        //
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(frame: CGRect) {
        let cgRect = CGRect.init(0, 0, 100, 100)
        super.init(frame: cgRect)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = UIColor.groupTableViewBackground
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        addSubview(blurEffectView)
        addSubview(leftContainerView)
        addSubview(rightContainerView)
        addSubview(titleLabel)
        leftContainerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        leftContainerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        leftContainerView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        leftContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 16).isActive = true
        rightContainerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        rightContainerView.heightAnchor.constraint(equalToConstant: 27).isActive = true
        rightContainerView.widthAnchor.constraint(equalToConstant: 27).isActive = true
        rightContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 16).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 16).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 220).isActive = true
        leftContainerView.addSubview(leftButton)
        rightContainerView.addSubview(rightButton)
        leftButton.leftAnchor.constraint(equalTo: leftContainerView.leftAnchor).isActive = true
        leftButton.topAnchor.constraint(equalTo: leftContainerView.topAnchor).isActive = true
        leftButton.rightAnchor.constraint(equalTo: leftContainerView.rightAnchor).isActive = true
        leftButton.bottomAnchor.constraint(equalTo: leftContainerView.bottomAnchor).isActive = true
        rightButton.leftAnchor.constraint(equalTo: rightContainerView.leftAnchor).isActive = true
        rightButton.topAnchor.constraint(equalTo: rightContainerView.topAnchor).isActive = true
        rightButton.rightAnchor.constraint(equalTo: rightContainerView.rightAnchor).isActive = true
        rightButton.bottomAnchor.constraint(equalTo: rightContainerView.bottomAnchor).isActive = true
    }
    
    func leftButtonTapped(completionHandler: (() -> Void)?) {
        self.completionHandler = completionHandler
    }
    
    func rightButtonTapped(completionHandler: (() -> Void)?) {
        self.completionHandler = completionHandler
    }
    
    
    @objc private func leftButtonSelected() {
        completionHandler?()
    }
    
    @objc private func rightButtonSelected() {
        completionHandler?()
    }
    
    
}

class NavigationBlurEffectView: UIVisualEffectView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.init(name: Constant.Fonts.casablancaRegular, size: 25)
        label.textColor = #colorLiteral(red: 0.1187598482, green: 0.1187873557, blue: 0.1187562123, alpha: 1)
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let leftContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let rightContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.alpha = 0.9
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let leftButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(nil, for: .normal)
        button.addTarget(self, action: #selector(leftButtonSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let rightButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(nil, for: .normal)
        button.addTarget(self, action: #selector(rightButtonSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var completionHandler: (() -> Void)?
    
    
    @IBInspectable var navigationTitle: String = "" {
        didSet {
            titleLabel.text = navigationTitle
            layoutIfNeeded()
        }
    }
    
    @IBInspectable var buttonImage: UIImage = UIImage() {
        didSet {
            leftButton.setImage(buttonImage, for: .normal)
            layoutIfNeeded()
        }
    }
    
    @IBInspectable var rightButtonImage: UIImage = UIImage() {
        didSet {
            rightButton.setImage(rightButtonImage, for: .normal)
            layoutIfNeeded()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        //
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(effect: UIVisualEffect?) {
        let blurEffect = UIBlurEffect(style: .dark)
        super.init(effect: blurEffect)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.alpha = 0.96
        self.contentView.alpha = 0.96
        self.contentView.addSubview(leftContainerView)
        self.contentView.addSubview(rightContainerView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(lineView)
        lineView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        lineView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        leftContainerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        leftContainerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        leftContainerView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        leftContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 16).isActive = true
        rightContainerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        rightContainerView.heightAnchor.constraint(equalToConstant: 27).isActive = true
        rightContainerView.widthAnchor.constraint(equalToConstant: 27).isActive = true
        rightContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 16).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 16).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 220).isActive = true
        leftContainerView.addSubview(leftButton)
        rightContainerView.addSubview(rightButton)
        leftButton.leftAnchor.constraint(equalTo: leftContainerView.leftAnchor).isActive = true
        leftButton.topAnchor.constraint(equalTo: leftContainerView.topAnchor).isActive = true
        leftButton.rightAnchor.constraint(equalTo: leftContainerView.rightAnchor).isActive = true
        leftButton.bottomAnchor.constraint(equalTo: leftContainerView.bottomAnchor).isActive = true
        rightButton.leftAnchor.constraint(equalTo: rightContainerView.leftAnchor).isActive = true
        rightButton.topAnchor.constraint(equalTo: rightContainerView.topAnchor).isActive = true
        rightButton.rightAnchor.constraint(equalTo: rightContainerView.rightAnchor).isActive = true
        rightButton.bottomAnchor.constraint(equalTo: rightContainerView.bottomAnchor).isActive = true
    }
    
    func leftButtonTapped(completionHandler: (() -> Void)?) {
        self.completionHandler = completionHandler
    }
    
    func rightButtonTapped(completionHandler: (() -> Void)?) {
        self.completionHandler = completionHandler
    }
    
    
    @objc private func leftButtonSelected() {
        completionHandler?()
    }
    
    @objc private func rightButtonSelected() {
        completionHandler?()
    }
    
    
}


//
//  DropButton.swift
//  Master
//
//  Created by Sina khanjani on 6/16/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//


import UIKit

protocol DropButtonDelegate {
    func selectedItemAt(index: Int, name: String)
}

class DropButton: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
    private var isOpen: Bool = false
    private var height: CGFloat = 0.0
    public var pickerView: UIPickerView?
    public var selectedItemAt: ((_ index: Int,_ name: String) -> Void)?
    private var defaultPickerViewData: Int?
    
    var button: UIButton?
    var shadowSize: CGFloat = 4.0
    var cornerRadius: CGFloat = 2.0
    var borderWidth: CGFloat = 0.0
    var borderColor: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    var selectedIndex = 0
    var data = [String]() {
        willSet {
            pickerView?.reloadAllComponents()
        }
    }
    
    var delegate: DropButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.height = frame.height
        self.frame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: 0)
        self.backgroundColor = #colorLiteral(red: 0.9452517629, green: 0.9459682107, blue: 0.9453627467, alpha: 1)
        openAnimate(defualtRow: self.defaultPickerViewData)
        setup()
    }
    
    init(height: CGFloat,defaultValue: Int?) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        self.height = height
        self.backgroundColor = #colorLiteral(red: 0.9452517629, green: 0.9459682107, blue: 0.9453627467, alpha: 1)
        setup()
        if let defaultValue = defaultValue {
            self.defaultPickerViewData = defaultValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
    }
    
    @objc private func tapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: superview)
        print(location)
        closeAnimate()
        self.superview?.endEditing(true)
    }
    
    func addTouch(parent: UIView) {
        parent.addSubview(self)
        //        let touch = UITapGestureRecognizer.init(target: self, action: #selector(tapped))
        //        superview!.addGestureRecognizer(touch)
    }
    
    func openAnimate(defualtRow:Int?) {
        guard let button = button else {
            return
        }
        guard !isOpen else { return }
        self.isOpen = true
        self.superview?.endEditing(true)
        let location = button.convert(CGPoint.zero, to: superview)
        let cgRect = CGRect.init(x: location.x, y: location.y + button.frame.height + 4.0, width: button.frame.width, height: 0)
        self.frame = cgRect
        self.configurePickerView(defualtRow: defualtRow)
        if let defualtRow = defualtRow {
            self.pickerView!.selectRow(defualtRow, inComponent: 0, animated: false)
        }
        let animator = UIViewPropertyAnimator.init(duration: 0, curve: .easeOut, animations: {
            self.layer.add(self.shadowAnimation, forKey: "shadowOpacity")
        })
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [.curveEaseOut], animations: {
            self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.height)
            let shadowPath = UIBezierPath(rect: CGRect(x: -self.shadowSize / 2,
                                                       y: -self.shadowSize / 2,
                                                       width: self.frame.size.width +  self.shadowSize,
                                                       height: self.frame.size.height +  self.shadowSize))
            self.layer.masksToBounds = false
            self.layer.shadowColor =  UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            self.layer.shadowOpacity = 0
            self.layer.shadowRadius =  self.cornerRadius
            self.layer.shadowPath = shadowPath.cgPath
            self.layoutIfNeeded()
            self.shadowAnimation.fillMode = CAMediaTimingFillMode.both
            self.shadowAnimation.fromValue = 0.06
            self.shadowAnimation.toValue = 0.06
            self.shadowAnimation.duration = 4000000000.4681
            animator.startAnimation()
        }) { (status) in
            //
        }
    }
    
    func closeAnimate() {
        guard isOpen else { return }
        self.isOpen = false
        self.shadowAnimation.fromValue = 0.0
        self.shadowAnimation.toValue = 0.0
        self.shadowAnimation.duration = 0.1
        self.pickerView?.removeFromSuperview()
        let animator = UIViewPropertyAnimator.init(duration: 0.1, curve: .easeInOut, animations: {
            self.layer.add(self.shadowAnimation, forKey: "shadowOpacity")
        })
        animator.startAnimation()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
            self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: 0)
        }) { (status) in
            //
        }
    }
    
    func closeImmediately() {
        guard isOpen else { return }
        self.isOpen = false
        self.shadowAnimation.fromValue = 0.0
        self.shadowAnimation.toValue = 0.0
        self.shadowAnimation.duration = 0.0
        self.pickerView?.removeFromSuperview()
        let animator = UIViewPropertyAnimator.init(duration: 0.0, curve: .easeInOut, animations: {
            self.layer.add(self.shadowAnimation, forKey: "shadowOpacity")
        })
        animator.startAnimation()
        UIView.animate(withDuration: 0.0, delay: 0.0, options: [.curveEaseOut], animations: {
            self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: 0)
        }) { (status) in
            //
        }
    }
    
    func buttonTapped() {
        if isOpen {
            closeAnimate()
        } else {
            NotificationCenter.default.post(name: Constant.Notify.dropNotify, object: nil)
            openAnimate(defualtRow: self.defaultPickerViewData)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.init(name: Constant.Fonts.fontOne, size: 16)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = data[row]
        pickerLabel?.textColor = UIColor.black
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.button?.setTitle(data[row], for: .normal)
        selectedIndex = row
        delegate?.selectedItemAt(index: row, name: data[row])
        self.selectedItemAt?(row,data[row])
        self.closeAnimate()
    }
    
    func configurePickerView(defualtRow: Int?) {
        let cgRect = CGRect.init(0, 0, button?.frame.width ?? 0.0, self.height)
        self.pickerView = UIPickerView.init(frame: cgRect)
        //        if let defualtRow = defualtRow {
        //            self.pickerView!.selectRow(defualtRow, inComponent: 0, animated: false)
        //        }
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
        self.pickerView?.backgroundColor = .clear
        if !data.isEmpty {
            self.button?.setTitle(data[defualtRow ?? selectedIndex], for: .normal)
            delegate?.selectedItemAt(index: selectedIndex, name: data[selectedIndex])
            self.selectedItemAt?(selectedIndex,data[selectedIndex])
        }
        //        pickerView?.selectRow(selectedIndex, inComponent: 0, animated: true)
        self.addSubview(pickerView!)
    }
    
    
}



//
//  FormalizationTypeSwitcherView.swift
//  Oq ot
//
//  Created by AvazbekOS on 28/07/22.
//

import UIKit

class FormalizationTypeSwitcherView: UIView {
    var didChangeSwitch: ((_ switchIndex: Int) -> Void)?
    var selectedSwitch = 1 {
        didSet {
            didChangeSwitch?(selectedSwitch)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var switcherView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 20
        v.backgroundColor = .white
        v.setStyleWithShadow(cornerRadius: 20)
        return v
    }()
    
    lazy var deliverySwitcherView: GradiendView = {
        let v = GradiendView()
//        v.backgroundColor = UIColor(hex: "#FF4000")
        v.gradientLayer.cornerRadius = 15
        v.isUserInteractionEnabled = true
        v.setStyleWithShadow(cornerRadius: 15)
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switcherDeliveryTapped)))
        return v
    }()
    
    lazy var deliverySwitchLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(13, "delivery".translate(), false, UIColor(hex: "#FFFFFF", alpha: 1.0), .center)
        return l
    }()
    
    lazy var pickupSwitcherView: UIView = {
        let v = UIView()
//        v.backgroundColor = .clear
        v.setStyleWithShadow(cornerRadius: 15)
        v.isUserInteractionEnabled = true
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switcherPickupTapped)))
        return v
    }()
    lazy var pickupSwitchLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(13, "pickup".translate(), false, UIColor(hex: "#000000", alpha: 1.0), .center)
        return l
    }()
    
    lazy var gradientLayer1: CAGradientLayer = {
        let l = CAGradientLayer()
//        l.frame = deliverySwitcherView.bounds
        l.colors = Theme.current.gradientLabelColors
        l.startPoint = CGPoint(x: 0, y: 1)
        l.endPoint = CGPoint(x: 1, y: 1)
        l.cornerRadius = 15
//        layer.insertSublayer(l, at: 0)
        return l
    }()
    lazy var gradientLayer2: CAGradientLayer = {
        let l = CAGradientLayer()
//        l.frame = pickupSwitcherView.bounds
        l.colors = Theme.current.gradientLabelColors
        l.startPoint = CGPoint(x: 0, y: 1)
        l.endPoint = CGPoint(x: 1, y: 1)
        l.cornerRadius = 15
//        layer.insertSublayer(l, at: 0)
        return l
    }()
    
    @objc private func switcherDeliveryTapped() {
        self.selectedSwitch = 1
        Utils.removeSublayer(pickupSwitcherView, layerIndex: 0)
        deliverySwitcherView.layer.insertSublayer(gradientLayer1, at: 0)
        
//        pickupSwitcherView.backgroundColor = .clear
//        deliverySwitcherView.backgroundColor = UIColor(hex: "#FF4000")
        pickupSwitchLabel.attributedText = NSAttributedString.getAttrTextWith(13, "pickup".translate(), false, UIColor(hex: "#000000", alpha: 1.0), .center)
        deliverySwitchLabel.attributedText = NSAttributedString.getAttrTextWith(13, "delivery".translate(), false, UIColor(hex: "#FFFFFF", alpha: 1.0), .center)
    }
    @objc private func switcherPickupTapped() {
        self.selectedSwitch = 2
        Utils.removeSublayer(deliverySwitcherView, layerIndex: 0)
        pickupSwitcherView.layer.insertSublayer(gradientLayer2, at: 0)
        
//        deliverySwitcherView.backgroundColor = .clear
//        pickupSwitcherView.backgroundColor = UIColor(hex: "#FF4000")
        deliverySwitchLabel.attributedText = NSAttributedString.getAttrTextWith(13, "delivery".translate(), false, UIColor(hex: "#000000", alpha: 1.0), .center)
        pickupSwitchLabel.attributedText = NSAttributedString.getAttrTextWith(13, "pickup".translate(), false, UIColor(hex: "#FFFFFF", alpha: 1.0), .center)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer1.frame = CGRect(x: 0, y: 0, width: (SCREEN_SIZE.width/2) - 24, height: (51 + (2*12)) - 2*(5 + 12))
        gradientLayer2.frame = CGRect(x: 0, y: 0, width: (SCREEN_SIZE.width/2) - 24, height: (51 + (2*12)) - 2*(5 + 12))
    }
    
    
    private func setupView() {
        addSubview(switcherView)
        switcherView.addSubview(deliverySwitcherView)
        switcherView.addSubview(pickupSwitcherView)
        deliverySwitcherView.addSubview(deliverySwitchLabel)
        pickupSwitcherView.addSubview(pickupSwitchLabel)
        
        switcherView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
        
        deliverySwitcherView.anchor(top: switcherView.topAnchor, leading: switcherView.leadingAnchor, bottom: switcherView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 0))
        deliverySwitcherView.widthAnchor.constraint(equalToConstant: (SCREEN_SIZE.width/2) - 24).isActive = true
        
        deliverySwitchLabel.anchor(top: deliverySwitcherView.topAnchor, leading: deliverySwitcherView.leadingAnchor, bottom: deliverySwitcherView.bottomAnchor, trailing: deliverySwitcherView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        pickupSwitcherView.anchor(top: switcherView.topAnchor, leading: nil, bottom: switcherView.bottomAnchor, trailing: switcherView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 5))
        pickupSwitcherView.widthAnchor.constraint(equalToConstant: (SCREEN_SIZE.width/2) - 24).isActive = true
        
        pickupSwitchLabel.anchor(top: pickupSwitcherView.topAnchor, leading: pickupSwitcherView.leadingAnchor, bottom: pickupSwitcherView.bottomAnchor, trailing: pickupSwitcherView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
}

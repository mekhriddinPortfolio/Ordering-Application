//
//  CancelDeletionView.swift
//  Oq ot
//
//  Created by AvazbekOS on 21/09/22.
//

import UIKit

class CancelDeletionView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setStyleWithShadow()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var containerView: GradiendView = {
        let v = GradiendView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.borderWidth = 0.0
        v.layer.cornerRadius = 10.0
        v.gradientLayer.cornerRadius = 10.0
        return v
    }()
    
    let textLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.backgroundColor = .clear
        lbl.attributedText = NSAttributedString.getAttrTextWith(13, "Ваша корзина была очищена".translate(), false, Theme.current.whiteColor, .left)
        return lbl
    }()
    
    
    let cancelLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.backgroundColor = .clear
        lbl.attributedText = NSAttributedString.getAttrTextWith(13, "Отменить".translate(), false,  Theme.current.whiteColor, .right)
        return lbl
    }()
    
    let cancelBottomView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 0.4)
        return v
    }()

    
    private func setupView() {
       addSubview(containerView)
        containerView.addSubview(textLabel)
        containerView.addSubview(cancelLabel)
        containerView.addSubview(cancelBottomView)
        containerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        textLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0), size: CGSize(width: "Ваша корзина была очищена".translate().widthOfString(usingFont: UIFont.systemFont(ofSize: 13)) , height: 15))
        textLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        cancelLabel.anchor(top: nil, leading: textLabel.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16), size: CGSize(width: 0, height: 15))
        cancelLabel.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor).isActive = true
    }

}

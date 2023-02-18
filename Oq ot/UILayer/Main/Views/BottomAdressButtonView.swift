//
//  BottomAdressButtonView.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 26/08/22.
//

import UIKit


class BottomAdressButtonView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var confirmButton: BaseButton = {
        let l = BaseButton(title: "done".translate(), size: 15)
        return l
    }()
    
    lazy var addNewView: UIView = {
        let  view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .clear
        view.setStyleWithShadow(cornerRadius: 5)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var addPlusLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(20, "+", false, UIColor(hex: "#FF4000"), .center)
        l.backgroundColor = .clear
        return l
    }()
    
    lazy var newAddressLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(13, "addAddress".translate(), false, UIColor(hex: "#7A7A7A"), .left)
        return l
    }()
    
    
    private func setupView() {
        addSubview(confirmButton)
        addSubview(addNewView)
        addNewView.addSubview(addPlusLabel)
        addNewView.addSubview(newAddressLabel)
   
        addNewView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 30 * RatioCoeff.height))
        
        addPlusLabel.anchor(top: addNewView.topAnchor, leading: addNewView.leadingAnchor, bottom: nil, trailing: nil, size: CGSize(width: 25, height: 25))
        addPlusLabel.centerYAnchor.constraint(equalTo: addNewView.centerYAnchor).isActive = true
        newAddressLabel.anchor(top: nil, leading: addPlusLabel.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 25))
        newAddressLabel.centerYAnchor.constraint(equalTo: addNewView.centerYAnchor).isActive = true
        confirmButton.anchor(top: addNewView.bottomAnchor, leading: addNewView.leadingAnchor, bottom: bottomAnchor, trailing: addNewView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
    }
}

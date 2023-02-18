//
//  CardNameView.swift
//  Oq ot
//
//  Created by AvazbekOS on 02/08/22.
//

import UIKit

class CardNameView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    
    lazy var cardNameLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .left
        l.text = "Название карты"
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = UIColor(hex: "#000000", alpha: 0.6)
        return l
    }()
    
    lazy var cardNameTextField: LoginTextField = {
        let tf = LoginTextField()
        tf.textColor = .black
        tf.autocorrectionType = .no
        tf.rightViewMode = .always
        tf.attributedPlaceholder = NSAttributedString.getAttrTextWith(16, "Введите название...", false, Theme.current.cardTextFieldColor, .left)
        
        return tf
    }()
    
    let cardNameContainerview: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.whiteBackColor
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 7
        v.layer.borderColor = Theme.current.borderOrangeColor.cgColor
        v.layer.borderWidth = 1.0
        return v
    }()

    private func setupView() {
        addSubview(cardNameLabel)
        addSubview(cardNameContainerview)
        cardNameContainerview.addSubview(cardNameTextField)
        
        cardNameLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 16))
        
        cardNameContainerview.anchor(top: cardNameLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 50))
        
        cardNameTextField.anchor(top: cardNameContainerview.topAnchor, leading: cardNameContainerview.leadingAnchor, bottom: cardNameContainerview.bottomAnchor, trailing: cardNameContainerview.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20), size: CGSize(width: 0, height: 50))
        cardNameTextField.centerYAnchor.constraint(equalTo: cardNameContainerview.centerYAnchor).isActive = true
    }
}

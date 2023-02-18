//
//  CardNumberView.swift
//  Oq ot
//
//  Created by AvazbekOS on 02/08/22.
//

import UIKit

class CardNumberView: UIView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    
    lazy var cardNumLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .left
        l.text = "Номер карты"
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = UIColor(hex: "#000000", alpha: 0.6)
        return l
    }()
    
    let cardNumContainerview: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.whiteBackColor
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 7
        v.layer.borderColor = Theme.current.borderOrangeColor.cgColor
        v.layer.borderWidth = 1.0
        return v
    }()
    
    lazy var cardNumTextField: LoginTextField = {
        let tf = LoginTextField()
        tf.keyboardType = .numberPad
        tf.textColor = .black
        tf.rightViewMode = .always
        tf.attributedPlaceholder = NSAttributedString.getAttrTextWith(16, "0000 0000 0000 0000", false, Theme.current.cardTextFieldColor, .left)
        
        return tf
    }()
    
    let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.borderOrangeColor
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 1
        return v
    }()
    
    lazy var cardNumImageView: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        im.image = UIImage.init(named: "qrcode")
        im.isUserInteractionEnabled = true
//        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cardQrCode)))
        return im
    }()

    private func setupView() {
        addSubview(cardNumLabel)
        addSubview(cardNumContainerview)
        cardNumContainerview.addSubview(cardNumImageView)
        cardNumContainerview.addSubview(separatorView)
        cardNumContainerview.addSubview(cardNumTextField)
        
        cardNumLabel.anchor(top: self.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 16))
        
        cardNumContainerview.anchor(top: cardNumLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 50))
        
        cardNumImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: cardNumContainerview.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15), size: CGSize(width: 22, height: 22))
        cardNumImageView.centerYAnchor.constraint(equalTo: cardNumContainerview.centerYAnchor).isActive = true
        
        separatorView.anchor(top: nil, leading: nil, bottom: nil, trailing: cardNumImageView.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15), size: CGSize(width: 1, height: 38))
        separatorView.centerYAnchor.constraint(equalTo: cardNumContainerview.centerYAnchor).isActive = true
        
        cardNumTextField.anchor(top: cardNumContainerview.topAnchor, leading: cardNumContainerview.leadingAnchor, bottom: cardNumContainerview.bottomAnchor, trailing: separatorView.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20), size: CGSize(width: 0, height: 50))
        cardNumTextField.centerYAnchor.constraint(equalTo: cardNumContainerview.centerYAnchor).isActive = true
        
    }

}

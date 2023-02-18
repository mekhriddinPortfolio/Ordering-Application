//
//  CardDateView.swift
//  Oq ot
//
//  Created by AvazbekOS on 02/08/22.
//

import UIKit

class CardDateView: UIView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    
    lazy var cardDateLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .left
        l.text = "Годен до"
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = UIColor(hex: "#000000", alpha: 0.6)
        return l
    }()
    
    
    // - - - - - - - - - - - - - - - - - - - - - - - -
    
    lazy var cardDateTextField: LoginTextField = {
        let tf = LoginTextField()
        tf.keyboardType = .numberPad
        tf.textColor = .black
        tf.rightViewMode = .always
        tf.attributedPlaceholder = NSAttributedString.getAttrTextWith(16, "00/00", false, Theme.current.cardTextFieldColor, .left)

        return tf
    }()

    let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.borderOrangeColor
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 1
        return v
    }()

    lazy var cardDateImageView: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        im.image = UIImage.init(named: "creditcard")
        return im
    }()

    lazy var cardDateContainerview: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.whiteBackColor
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 7
        v.layer.borderColor = Theme.current.borderOrangeColor.cgColor
        v.layer.borderWidth = 1.0
        return v
    }()

    private func setupView() {
        addSubview(cardDateLabel)
        
        addSubview(cardDateContainerview)
        cardDateContainerview.addSubview(cardDateImageView)
        cardDateContainerview.addSubview(separatorView)
        cardDateContainerview.addSubview(cardDateTextField)
        
        cardDateLabel.anchor(top: self.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 16))
        
        cardDateContainerview.anchor(top: cardDateLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 50))
        
        cardDateImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: cardDateContainerview.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15), size: CGSize(width: 22, height: 22))
        cardDateImageView.centerYAnchor.constraint(equalTo: cardDateContainerview.centerYAnchor).isActive = true
        
        separatorView.anchor(top: nil, leading: nil, bottom: nil, trailing: cardDateImageView.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15), size: CGSize(width: 1, height: 38))
        separatorView.centerYAnchor.constraint(equalTo: cardDateContainerview.centerYAnchor).isActive = true
        
        cardDateTextField.anchor(top: cardDateContainerview.topAnchor, leading: cardDateContainerview.leadingAnchor, bottom: cardDateContainerview.bottomAnchor, trailing: separatorView.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20), size: CGSize(width: 0, height: 50))
        cardDateTextField.centerYAnchor.constraint(equalTo: cardDateContainerview.centerYAnchor).isActive = true
        
    }
}

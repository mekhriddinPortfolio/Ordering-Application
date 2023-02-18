//
//  DeliveryTopView.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 06/07/22.
//


import UIKit

class DeliveryTopView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        setupView()
    }
    
    
    lazy var deliveryTimeLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(15, "deliveryMinutes".translate(), false, UIColor(hex: "#000000", alpha: 0.7), .left)
        return l
    }()
    
    lazy var deliveryInfoLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(13, "freeDelivery".translate(), false, UIColor(hex: "#000000", alpha: 0.4), .left)
        return l
    }()
    
    lazy var deliveryImageView: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        im.image = UIImage.init(named: "gradient")
       
        return im
    }()
    
    lazy var infoImageView: UIImageView = {
        let im = UIImageView()
        im.image = UIImage.init(named: "infoCircle")
        return im
    }()
    
    lazy var bottomSeparatorView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#F1F1F1")
        return v
    }()
    
    
    private func setupView() {
        addSubview(deliveryImageView)
        addSubview(deliveryInfoLabel)
        addSubview(deliveryTimeLabel)
        addSubview(bottomSeparatorView)
        addSubview(infoImageView)
        
        deliveryImageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 75, height: 75))
        deliveryImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        infoImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 20, height: 20))
        infoImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -15).isActive = true
        
        deliveryTimeLabel.anchor(top: nil, leading: deliveryImageView.trailingAnchor, bottom: nil, trailing: infoImageView.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 15), size: CGSize(width: 0, height: 20))
        deliveryTimeLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -15).isActive = true
        
        deliveryInfoLabel.anchor(top: nil, leading: deliveryImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 5), size: CGSize(width: 0, height: 20))
        deliveryInfoLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
        
        bottomSeparatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 25, bottom: 5, right: 25), size: CGSize(width: 0, height: 1))
        
    }
    
    
}



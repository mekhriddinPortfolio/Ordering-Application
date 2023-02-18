//
//  BasketEmptyView.swift
//  Oq ot
//
//  Created by AvazbekOS on 12/07/22.
//

import UIKit

class BasketEmptyView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
   
    }
    
    lazy var busketEmptyTitleLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(17, "emptyCart".translate(), false, UIColor(hex: "#000000", alpha: 0.7), .center)
        return l
    }()
    
    lazy var busketEmptyDescLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.attributedText = NSAttributedString.getAttrTextWith(13, "addItemtoCart".translate(), false, UIColor(hex: "#000000", alpha: 0.4), .center)
        return l
    }()
    
    lazy var backetEmptyImageView: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        im.image = UIImage.init(named: "emptyImage")
       
        return im
    }()
    
    lazy var goProductsButton: BaseButton = {
        let l = BaseButton(title: "goShopping".translate(), size: 15)
        l.isUserInteractionEnabled = true
        return l
    }()
 
    
    private func setupView() {
        addSubview(busketEmptyTitleLabel)
        addSubview(busketEmptyDescLabel)
        addSubview(backetEmptyImageView)
        addSubview(goProductsButton)
        backetEmptyImageView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0), size: CGSize(width: 150 * RatioCoeff.width, height: 150 * RatioCoeff.height))
        backetEmptyImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        busketEmptyTitleLabel.anchor(top: backetEmptyImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 30, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 20))
        busketEmptyDescLabel.anchor(top: busketEmptyTitleLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 15))
        goProductsButton.anchor(top: busketEmptyDescLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 256, height: 55))
        goProductsButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }

}

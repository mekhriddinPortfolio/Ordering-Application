//
//  FormalizationPickupCell.swift
//  Oq ot
//
//  Created by AvazbekOS on 27/07/22.
//

import UIKit

class FormalizationPickupCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var firstPartLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(17, "deliveryAddress".translate(), false, UIColor(hex: "#000000", alpha: 0.7), .left)
        return l
    }()
    
    var mapViewAndInfo: UIView = {
        let v = UIView()
        v.layer.backgroundColor = UIColor.white.cgColor
        v.layer.cornerRadius = 15.0
        v.setStyleWithShadow()
        return v
    }()
    
    var yandexMapsLocationView: YandexMapsLocationsView = {
        let v = YandexMapsLocationsView()
        v.layer.cornerRadius = 15.0
        return v
    }()
    
    lazy var numberMapImageView: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        iV.isUserInteractionEnabled = true
        iV.image = UIImage(named: "formalizationMapNum")
        return iV
    }()
    lazy var countMapImageView: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        iV.isUserInteractionEnabled = true
        iV.image = UIImage(named: "formalizationMapCount")
        return iV
    }()
    
    lazy var streetLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(15, "4140 Parker Rd. Allentown, New Mexico 31134", false, UIColor(hex: "#848484", alpha: 1.0), .left)
        return l
    }()
    lazy var pickupEnableLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(13, "Самовывоз доступен", false, UIColor(hex: "#000000", alpha: 0.4), .left)
        return l
    }()
    lazy var pickupTimeLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(15, "Круглосуточно", false, UIColor(hex: "#000000", alpha: 0.6), .left)
        return l
    }()
    lazy var phoneLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(13, "Телефон", false, UIColor(hex: "#000000", alpha: 0.4), .left)
        return l
    }()
    lazy var placePhoneLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(15, "+998 ( 90 ) 461 54 21", false, UIColor(hex: "#000000", alpha: 0.6), .left)
        return l
    }()

    private func setupView() {
        addSubview(firstPartLabel)
        addSubview(mapViewAndInfo)
        mapViewAndInfo.addSubview(yandexMapsLocationView)
        mapViewAndInfo.addSubview(streetLabel)
        mapViewAndInfo.addSubview(pickupEnableLabel)
        mapViewAndInfo.addSubview(pickupTimeLabel)
        mapViewAndInfo.addSubview(phoneLabel)
        mapViewAndInfo.addSubview(placePhoneLabel)
        
        yandexMapsLocationView.addSubview(numberMapImageView)
        yandexMapsLocationView.addSubview(countMapImageView)
        
        firstPartLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 30, left: 12, bottom: 0, right: 16), size: CGSize(width: 0, height: 20))
        // +50
        mapViewAndInfo.anchor(top: firstPartLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 310))
        yandexMapsLocationView.anchor(top: mapViewAndInfo.topAnchor, leading: mapViewAndInfo.leadingAnchor, bottom: nil, trailing: mapViewAndInfo.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 150))
        streetLabel.anchor(top: yandexMapsLocationView.bottomAnchor, leading: mapViewAndInfo.leadingAnchor, bottom: nil, trailing: mapViewAndInfo.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 17))
        
        numberMapImageView.anchor(top: nil, leading: nil, bottom: yandexMapsLocationView.bottomAnchor, trailing: yandexMapsLocationView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 10), size: CGSize(width: 43, height: 43))
        countMapImageView.anchor(top: numberMapImageView.topAnchor, leading: numberMapImageView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: -4, left: -7, bottom: 0, right: 0), size: CGSize(width: 20, height: 20))
        
        pickupEnableLabel.anchor(top: streetLabel.bottomAnchor, leading: mapViewAndInfo.leadingAnchor, bottom: nil, trailing: mapViewAndInfo.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 15))
        pickupTimeLabel.anchor(top: pickupEnableLabel.bottomAnchor, leading: mapViewAndInfo.leadingAnchor, bottom: nil, trailing: mapViewAndInfo.trailingAnchor, padding: UIEdgeInsets(top: 3, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 17))
        
        phoneLabel.anchor(top: pickupTimeLabel.bottomAnchor, leading: mapViewAndInfo.leadingAnchor, bottom: nil, trailing: mapViewAndInfo.trailingAnchor, padding: UIEdgeInsets(top: 21, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 15))
        placePhoneLabel.anchor(top: phoneLabel.bottomAnchor, leading: mapViewAndInfo.leadingAnchor, bottom: nil, trailing: mapViewAndInfo.trailingAnchor, padding: UIEdgeInsets(top: 3, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 17))
        // 309 + 20
        // height of this cell = 379
    }
}

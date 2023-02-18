//
//  ProfileAddressCell.swift
//  Oq ot
//
//  Created by AvazbekOS on 06/07/22.
//

import UIKit

class ProfileAddressCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.grayCellColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        return lbl
    }()
    
    lazy var imageV: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        iV.image = UIImage.init(named: "EmptyCircle")
        return iV
    }()
    
    lazy var settingsView: UIView = {
        let  view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        view.setStyleWithShadow(cornerRadius: 5)
        return view
    }()
    
    lazy var imageSettingsV: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        iV.image = UIImage.init(named: "mapSettings")
        return iV
    }()
    
    lazy var deleteView: UIView = {
        let  view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        view.setStyleWithShadow(cornerRadius: 5)
        return view
    }()
    
    lazy var imageDeleteV: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        iV.image = UIImage.init(named: "delete")
        return iV
    }()
    
    
    func setItem(item: String) {
        titleLabel.attributedText = NSAttributedString.getAttrTextWith(14, item, false ,UIColor(hex: "#000000", alpha: 0.5), .left, 0, 0, .byTruncatingTail)
    }
    
    private func setupView() {
        addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(imageV)
        backView.addSubview(settingsView)
        backView.addSubview(deleteView)
        settingsView.addSubview(imageSettingsV)
        deleteView.addSubview(imageDeleteV)
        
        backView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        
        imageV.anchor(top: backView.topAnchor, leading: backView.leadingAnchor, bottom: backView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 0), size: CGSize(width: 56 - (2*13), height: 0))
//        imageV.centerYAnchor.constraint(equalTo: backView.centerYAnchor).isActive = true
        
        deleteView.anchor(top: nil, leading: nil, bottom: nil, trailing: backView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16), size: CGSize(width: 36, height: 36))
        deleteView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageDeleteV.anchor(top: deleteView.topAnchor, leading: deleteView.leadingAnchor, bottom: deleteView.bottomAnchor, trailing: deleteView.trailingAnchor, padding: UIEdgeInsets(top: 9.75, left: 11.25, bottom: 9.75, right: 11.25))
        
        settingsView.anchor(top: nil, leading: nil, bottom: nil, trailing: deleteView.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7), size: CGSize(width: 36, height: 36))
        settingsView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageSettingsV.anchor(top: settingsView.topAnchor, leading: settingsView.leadingAnchor, bottom: settingsView.bottomAnchor, trailing: settingsView.trailingAnchor, padding: UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9))
        
        titleLabel.anchor(top: nil, leading: imageV.trailingAnchor, bottom: nil, trailing: settingsView.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 7))
        titleLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor).isActive = true
    }

}

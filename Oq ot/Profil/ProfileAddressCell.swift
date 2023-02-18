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
        setupView()
    }
    
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        return lbl
    }()
    
    lazy var imageV: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        iV.image = UIImage.init(named: "emptyCircle")
        return iV
    }()
    
    func setItem(item: ProfileAddressDataModel) {
        titleLabel.attributedText = NSAttributedString.getAttrTextWith(14, item.title ?? "", false ,UIColor(hex: "#000000", alpha: 0.5), .left, 0, 0, .byTruncatingTail)
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(imageV)
        imageV.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 10), size: CGSize(width: 30, height: 30))
        imageV.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.anchor(top: nil, leading: imageV.trailingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 13))
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor(hex: "#F3F2F8")
    }
}

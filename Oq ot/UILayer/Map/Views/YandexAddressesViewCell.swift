//
//  YandexAddressesViewCell.swift
//  Oq ot
//
//  Created by AvazbekOS on 06/07/22.
//

import UIKit

class YandexAddressesViewCell: UICollectionViewCell {
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
        lbl.numberOfLines = 2
        return lbl
    }()
    
    lazy var imageV: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        return iV
    }()
    
    func setItem(item: String) {
        titleLabel.attributedText = NSAttributedString.getAttrTextWith(15, item, false ,UIColor(hex: "#000000", alpha: 0.5), .left)
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(imageV)
        imageV.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 20), size: CGSize(width: 25, height: 25))
        imageV.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.anchor(top: nil, leading: imageV.trailingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0), size: CGSize(width: 0, height: 32))
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}

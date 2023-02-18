//
//  MenuSlidingVIewControllerCell.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 23/08/22.
//

import UIKit

class MenuSlidingVIewControllerCell: UICollectionViewCell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.textAlignment = .left
        label.textColor = UIColor(hex: "#000000", alpha: 0.6)
        label.font = UIFont.systemFont(ofSize: 14)
        addSubview(label)
        label.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


